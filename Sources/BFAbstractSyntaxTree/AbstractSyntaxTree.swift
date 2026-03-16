import BFCommand
import LLVMSwift

public struct AbstractSyntaxTree: Equatable {
    
    public enum Node: Equatable {
        case incrementPointer
        case decrementPointer
        case incrementByte
        case decrementByte
        case outputByte
        case inputByte
        case loop([Node])
    }
    
    public enum InitializationError: Error {
        case unmatchedStartLoop
        case unmatchedEndLoop
    }
    
    public let root: [Node]
    
    @inlinable public init(_ commands: some Sequence<Command>) throws(InitializationError) {
        var ancestors = [[]] as [[Node]]
        for command in commands {
            switch command {
            case .incrementPointer:
                ancestors[ancestors.endIndex - 1].append(.incrementPointer)
            case .decrementPointer:
                ancestors[ancestors.endIndex - 1].append(.decrementPointer)
            case .incrementByte:
                ancestors[ancestors.endIndex - 1].append(.incrementByte)
            case .decrementByte:
                ancestors[ancestors.endIndex - 1].append(.decrementByte)
            case .outputByte:
                ancestors[ancestors.endIndex - 1].append(.outputByte)
            case .inputByte:
                ancestors[ancestors.endIndex - 1].append(.inputByte)
            case .startLoop:
                ancestors.append([])
            case .endLoop:
                guard ancestors.count >= 2 else {
                    throw .unmatchedEndLoop
                }
                let children = ancestors.removeLast()
                ancestors[ancestors.endIndex - 1].append(.loop(children))
            }
        }
        guard ancestors.count == 1 else {
            throw .unmatchedStartLoop
        }
        self.root = ancestors[0]
    }
}

extension AbstractSyntaxTree {}

extension AbstractSyntaxTree.Node {
    
    @inlinable public func buildLLVM(
        context: LLVMContext,
        builder: LLVMBuilder,
        putchar: LLVMFunction<LLVMInt32, LLVMInt32>,
        getchar: LLVMFunction<LLVMInt32>,
        main: LLVMFunction<LLVMInt32>,
        failureBlock: LLVMBasicBlock,
        pointerToPointer: LLVMPointer<LLVMPointer<LLVMInt8>>,
        bytes: LLVMArray<LLVMInt8>
    ) {
        let byteType = context.makeInt8Type()
        let int32Type = context.makeInt32Type()
        switch self {
        case .incrementPointer:
            let successBlock = context.appendBasicBlock(to: main, name: "success")
            let pointer = builder.buildLoad(of: LLVMPointerType(elementType: byteType), from: pointerToPointer, name: "pointer")
            let incrementedPointer = builder.buildGetElementPointer(
                to: byteType,
                indexing: pointer,
                at: LLVMInt32(1 as Int32, type: int32Type),
                name: "incrementedpointer",
                noWrapFlags: [.inBounds]
            )
            let incrementedPointerIsInBounds = builder.buildComparison(
                of: incrementedPointer,
                to: LLVMPointer(to: byteType, indexing: bytes, at: LLVMInt32(0 as UInt32, type: int32Type), noWrapFlags: [.inBounds]),
                using: .unsignedLessThan,
                name: "incrementedpointerisinbounds"
            )
            builder.buildBranch(to: successBlock, if: incrementedPointerIsInBounds, elseTo: failureBlock)
            builder.position(atEndOf: successBlock)
            builder.buildStore(of: incrementedPointer, to: pointerToPointer)
        case .decrementPointer:
            let successBlock = context.appendBasicBlock(to: main, name: "success")
            let pointer = builder.buildLoad(of: LLVMPointerType(elementType: byteType), from: pointerToPointer, name: "pointer")
            let decrementedPointerWillBeInBounds = builder.buildComparison(
                of: pointer,
                to: LLVMPointer(to: byteType, indexing: bytes, at: LLVMInt32(30000 as UInt32, type: int32Type), noWrapFlags: [.inBounds]),
                using: .unsignedGreaterThan,
                name: "decrementedpointerwillbeinbounds"
            )
            builder.buildBranch(to: successBlock, if: decrementedPointerWillBeInBounds, elseTo: failureBlock)
            builder.position(atEndOf: successBlock)
            let decrementedPointer = builder.buildGetElementPointer(
                to: byteType,
                indexing: pointer,
                at: LLVMInt32(-1 as Int32, type: int32Type),
                name: "decrementedpointer",
                noWrapFlags: [.inBounds]
            )
            builder.buildStore(of: decrementedPointer, to: pointerToPointer)
        case .incrementByte:
            let pointer = builder.buildLoad(of: LLVMPointerType(elementType: byteType), from: pointerToPointer, name: "pointer")
            let byte = builder.buildLoad(of: byteType, from: pointer, name: "byte")
            let incrementedByte = builder.buildAddition(of: LLVMInt8(1 as UInt8, type: byteType), to: byte, name: "incrementedbyte")
            builder.buildStore(of: incrementedByte, to: pointer)
        case .decrementByte:
            let pointer = builder.buildLoad(of: LLVMPointerType(elementType: byteType), from: pointerToPointer, name: "pointer")
            let byte = builder.buildLoad(of: byteType, from: pointer, name: "byte")
            let decrementedByte = builder.buildSubtraction(of: LLVMInt8(1 as UInt8, type: byteType), from: byte, name: "decrementedbyte")
            builder.buildStore(of: decrementedByte, to: pointer)
        case .outputByte:
            let successBlock = context.appendBasicBlock(to: main, name: "success")
            let pointer = builder.buildLoad(of: LLVMPointerType(elementType: byteType), from: pointerToPointer, name: "pointer")
            let byte = builder.buildLoad(of: byteType, from: pointer, name: "byte")
            let zeroExtendedByte = builder.buildZeroExtension(of: byte, to: int32Type, name: "zeroextendedbyte")
            let putcharReturnValue = builder.buildCall(to: putchar, passing: zeroExtendedByte, returning: int32Type, name: "putcharreturnvalue")
            let putcharReturnedEOF = builder.buildComparison(
                of: putcharReturnValue,
                to: LLVMInt32(0 as Int32, type: int32Type),
                using: .signedLessThan,
                name: "putcharreturnedeof"
            )
            builder.buildBranch(to: failureBlock, if: putcharReturnedEOF, elseTo: successBlock)
            builder.position(atEndOf: successBlock)
        case .inputByte:
            let successBlock = context.appendBasicBlock(to: main, name: "success")
            let getcharReturnValue = builder.buildCall(to: getchar, returning: int32Type, name: "getcharreturnvalue")
            let getcharReturnedEOF = builder.buildComparison(
                of: getcharReturnValue,
                to: LLVMInt32(0 as Int32, type: int32Type),
                using: .signedLessThan,
                name: "getcharreturnedeof"
            )
            builder.buildBranch(to: failureBlock, if: getcharReturnedEOF, elseTo: successBlock)
            builder.position(atEndOf: successBlock)
            let pointer = builder.buildLoad(of: LLVMPointerType(elementType: byteType), from: pointerToPointer, name: "pointer")
            let byte = builder.buildTruncation(of: getcharReturnValue, to: byteType, name: "byte")
            builder.buildStore(of: byte, to: pointer)
        case let .loop(children):
            let body = context.appendBasicBlock(to: main, name: "body")
            let exit = context.makeBasicBlock(name: "exit")
            let pointerType = LLVMPointerType(elementType: byteType)
            let zero = LLVMInt8(0 as UInt8, type: byteType)
            let pointer = builder.buildLoad(of: pointerType, from: pointerToPointer, name: "pointer")
            let byte = builder.buildLoad(of: byteType, from: pointer, name: "byte")
            let byteIsZero = builder.buildComparison(of: byte, to: zero, using: .equalTo, name: "byteiszero")
            builder.buildBranch(to: exit, if: byteIsZero, elseTo: body)
            builder.position(atEndOf: exit)
            for child in children {
                child.buildLLVM(
                    context: context,
                    builder: builder,
                    putchar: putchar,
                    getchar: getchar,
                    main: main,
                    failureBlock: failureBlock,
                    pointerToPointer: pointerToPointer,
                    bytes: bytes
                )
            }
            main.appendBasicBlock(exit)
            let apointer = builder.buildLoad(of: pointerType, from: pointerToPointer, name: "pointer")
            let abyte = builder.buildLoad(of: byteType, from: apointer, name: "byte")
            let abyteIsZero = builder.buildComparison(of: abyte, to: zero, using: .equalTo, name: "byteiszero")
            builder.buildBranch(to: exit, if: abyteIsZero, elseTo: body)
            builder.position(atEndOf: exit)
        }
    }
}
