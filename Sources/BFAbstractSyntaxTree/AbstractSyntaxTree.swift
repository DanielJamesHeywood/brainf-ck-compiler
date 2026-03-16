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
        switch self {
        case .incrementPointer:
            let successBlock = context.makeBasicBlock(name: "success")
            main.appendBasicBlock(successBlock)
            let pointer = builder.buildLoad(of: LLVMPointerType(elementType: context.makeInt8Type()), from: pointerToPointer, name: "pointer")
            let incrementedPointer = builder.buildGetElementPointer(
                to: context.makeInt8Type(),
                indexing: pointer,
                at: LLVMInt64(1 as Int64, type: context.makeInt64Type()),
                name: "incrementedpointer",
                noWrapFlags: [.inBounds]
            )
            let incrementedPointerIsInBounds = builder.buildComparison(
                of: incrementedPointer,
                to: LLVMPointer(
                    to: context.makeInt8Type(),
                    indexing: bytes,
                    at: LLVMInt64(0 as UInt64, type: context.makeInt64Type()),
                    noWrapFlags: [.inBounds]
                ),
                using: .unsignedLessThan,
                name: "incrementedpointerisinbounds"
            )
            builder.buildBranch(to: successBlock, if: incrementedPointerIsInBounds, elseTo: failureBlock)
            builder.position(atEndOf: successBlock)
            builder.buildStore(of: incrementedPointer, to: pointerToPointer)
        case .decrementPointer:
            let successBlock = context.makeBasicBlock(name: "success")
            main.appendBasicBlock(successBlock)
            let pointer = builder.buildLoad(of: LLVMPointerType(elementType: context.makeInt8Type()), from: pointerToPointer, name: "pointer")
            let decrementedPointerWillBeInBounds = builder.buildComparison(
                of: pointer,
                to: LLVMPointer(
                    to: context.makeInt8Type(),
                    indexing: bytes,
                    at: LLVMInt64(30000 as UInt64, type: context.makeInt64Type()),
                    noWrapFlags: [.inBounds]
                ),
                using: .unsignedGreaterThan,
                name: "decrementedpointerwillbeinbounds"
            )
            builder.buildBranch(to: successBlock, if: decrementedPointerWillBeInBounds, elseTo: failureBlock)
            builder.position(atEndOf: successBlock)
            let decrementedPointer = builder.buildGetElementPointer(
                to: context.makeInt8Type(),
                indexing: pointer,
                at: LLVMInt64(-1 as Int64, type: context.makeInt64Type()),
                name: "decrementedpointer",
                noWrapFlags: [.inBounds]
            )
            builder.buildStore(of: decrementedPointer, to: pointerToPointer)
        case .incrementByte:
            let pointer = builder.buildLoad(of: LLVMPointerType(elementType: context.makeInt8Type()), from: pointerToPointer, name: "pointer")
            let byte = builder.buildLoad(of: context.makeInt8Type(), from: pointer, name: "byte")
            let incrementedByte = builder.buildAddition(
                of: LLVMInt8(1 as UInt8, type: context.makeInt8Type()),
                to: byte,
                name: "incrementedbyte"
            )
            builder.buildStore(of: incrementedByte, to: pointer)
        case .decrementByte:
            let pointer = builder.buildLoad(of: LLVMPointerType(elementType: context.makeInt8Type()), from: pointerToPointer, name: "pointer")
            let byte = builder.buildLoad(of: context.makeInt8Type(), from: pointer, name: "byte")
            let decrementedByte = builder.buildSubtraction(
                of: LLVMInt8(1 as UInt8, type: context.makeInt8Type()),
                from: byte,
                name: "decrementedbyte"
            )
            builder.buildStore(of: decrementedByte, to: pointer)
        case .outputByte:
            let successBlock = context.makeBasicBlock(name: "success")
            main.appendBasicBlock(successBlock)
            let pointer = builder.buildLoad(of: LLVMPointerType(elementType: context.makeInt8Type()), from: pointerToPointer, name: "pointer")
            let byte = builder.buildLoad(of: context.makeInt8Type(), from: pointer, name: "byte")
            let zeroExtendedByte = builder.buildZeroExtension(of: byte, to: context.makeInt32Type(), name: "zeroextendedbyte")
            let putcharReturnValue = builder.buildCall(
                to: putchar,
                passing: zeroExtendedByte,
                returning: context.makeInt32Type(),
                name: "putcharreturnvalue"
            )
            let putcharReturnedEOF = builder.buildComparison(
                of: putcharReturnValue,
                to: LLVMInt32(0 as UInt32, type: context.makeInt32Type()),
                using: .signedLessThan,
                name: "putcharreturnedeof"
            )
            builder.buildBranch(to: failureBlock, if: putcharReturnedEOF, elseTo: successBlock)
            builder.position(atEndOf: successBlock)
        case .inputByte:
            let successBlock = context.makeBasicBlock(name: "success")
            main.appendBasicBlock(successBlock)
            let getcharReturnValue = builder.buildCall(to: getchar, returning: context.makeInt32Type(), name: "getcharreturnvalue")
            let getcharReturnedEOF = builder.buildComparison(
                of: getcharReturnValue,
                to: LLVMInt32(0 as UInt32, type: context.makeInt32Type()),
                using: .signedLessThan,
                name: "getcharreturnedeof"
            )
            builder.buildBranch(to: failureBlock, if: getcharReturnedEOF, elseTo: successBlock)
            builder.position(atEndOf: successBlock)
            let pointer = builder.buildLoad(of: LLVMPointerType(elementType: context.makeInt8Type()), from: pointerToPointer, name: "pointer")
            let byte = builder.buildTruncation(of: getcharReturnValue, to: context.makeInt8Type(), name: "byte")
            builder.buildStore(of: byte, to: pointer)
        case let .loop(children):
            let bodyBlock = context.makeBasicBlock(name: "body")
            let exitBlock = context.makeBasicBlock(name: "exit")
            main.appendBasicBlock(bodyBlock)
            let pointerBeforeBody = builder.buildLoad(
                of: LLVMPointerType(elementType: context.makeInt8Type()),
                from: pointerToPointer,
                name: "pointer"
            )
            let byteBeforeBody = builder.buildLoad(of: context.makeInt8Type(), from: pointerBeforeBody, name: "byte")
            let byteIsZeroBeforeBody = builder.buildComparison(
                of: byteBeforeBody,
                to: LLVMInt8(0 as UInt8, type: context.makeInt8Type()),
                using: .equalTo,
                name: "byteiszero"
            )
            builder.buildBranch(to: exitBlock, if: byteIsZeroBeforeBody, elseTo: bodyBlock)
            builder.position(atEndOf: bodyBlock)
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
            main.appendBasicBlock(exitBlock)
            let pointerAfterBody = builder.buildLoad(
                of: LLVMPointerType(elementType: context.makeInt8Type()),
                from: pointerToPointer,
                name: "pointer"
            )
            let byteAfterBody = builder.buildLoad(of: context.makeInt8Type(), from: pointerAfterBody, name: "byte")
            let byteIsZeroAfterBody = builder.buildComparison(
                of: byteAfterBody,
                to: LLVMInt8(0 as UInt8, type: context.makeInt8Type()),
                using: .equalTo,
                name: "byteiszero"
            )
            builder.buildBranch(to: exitBlock, if: byteIsZeroAfterBody, elseTo: bodyBlock)
            builder.position(atEndOf: exitBlock)
        }
    }
}
