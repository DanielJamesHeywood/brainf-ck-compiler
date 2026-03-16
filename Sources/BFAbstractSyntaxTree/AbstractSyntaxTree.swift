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
    
    @inlinable public func build(
        context: LLVMContext,
        builder: LLVMBuilder,
        putchar: LLVMFunction<LLVMInt32, LLVMInt32>,
        getchar: LLVMFunction<LLVMInt32>,
        main: LLVMFunction<LLVMInt32>,
        failureBlock: LLVMBasicBlock,
        pointerToPointer: LLVMPointer<LLVMPointer<LLVMInt8, 0>, 0>,
        bytes: LLVMArray<LLVMInt8, 30000>
    ) {
        switch self {
        case .incrementPointer:
            let successBlock = context.makeBasicBlock(name: "success")
            main.appendBasicBlock(successBlock)
            let pointer = builder.buildLoad(from: pointerToPointer, name: "pointer")
            let incrementedPointer = builder.buildGetElementPointer(
                indexing: pointer,
                at: context.makeInt64(1 as Int64),
                name: "incrementedpointer",
                noWrapFlags: [.inBounds]
            )
            let incrementedPointerIsInBounds = builder.buildComparison(
                of: incrementedPointer,
                to: context.makePointer(indexing: bytes, at: context.makeInt64(30000 as UInt64), noWrapFlags: [.inBounds]),
                using: .unsignedLessThan,
                name: "incrementedpointerisinbounds"
            )
            builder.buildBranch(to: successBlock, if: incrementedPointerIsInBounds, elseTo: failureBlock)
            builder.position(atEndOf: successBlock)
            builder.buildStore(of: incrementedPointer, to: pointerToPointer)
        case .decrementPointer:
            let successBlock = context.makeBasicBlock(name: "success")
            main.appendBasicBlock(successBlock)
            let pointer = builder.buildLoad(from: pointerToPointer, name: "pointer")
            let decrementedPointerWillBeInBounds = builder.buildComparison(
                of: pointer,
                to: context.makePointer(indexing: bytes, at: context.makeInt64(0 as UInt64), noWrapFlags: [.inBounds]),
                using: .unsignedGreaterThan,
                name: "decrementedpointerwillbeinbounds"
            )
            builder.buildBranch(to: successBlock, if: decrementedPointerWillBeInBounds, elseTo: failureBlock)
            builder.position(atEndOf: successBlock)
            let decrementedPointer = builder.buildGetElementPointer(
                indexing: pointer,
                at: context.makeInt64(-1 as Int64),
                name: "decrementedpointer",
                noWrapFlags: [.inBounds]
            )
            builder.buildStore(of: decrementedPointer, to: pointerToPointer)
        case .incrementByte:
            let pointer = builder.buildLoad(from: pointerToPointer, name: "pointer")
            let byte = builder.buildLoad(from: pointer, name: "byte")
            let incrementedByte = builder.buildAddition(of: context.makeInt8(1 as UInt8), to: byte, name: "incrementedbyte")
            builder.buildStore(of: incrementedByte, to: pointer)
        case .decrementByte:
            let pointer = builder.buildLoad(from: pointerToPointer, name: "pointer")
            let byte = builder.buildLoad(from: pointer, name: "byte")
            let decrementedByte = builder.buildSubtraction(of: context.makeInt8(1 as UInt8), from: byte, name: "decrementedbyte")
            builder.buildStore(of: decrementedByte, to: pointer)
        case .outputByte:
            let successBlock = context.makeBasicBlock(name: "success")
            main.appendBasicBlock(successBlock)
            let pointer = builder.buildLoad(from: pointerToPointer, name: "pointer")
            let byte = builder.buildLoad(from: pointer, name: "byte")
            let zeroExtendedByte = builder.buildZeroExtension(of: byte, name: "zeroextendedbyte")
            let putcharReturnValue = builder.buildCall(to: putchar, passing: zeroExtendedByte, name: "putcharreturnvalue")
            let putcharReturnedEOF = builder.buildComparison(
                of: putcharReturnValue,
                to: context.makeInt32(0 as UInt32),
                using: .signedLessThan,
                name: "putcharreturnedeof"
            )
            builder.buildBranch(to: failureBlock, if: putcharReturnedEOF, elseTo: successBlock)
            builder.position(atEndOf: successBlock)
        case .inputByte:
            let successBlock = context.makeBasicBlock(name: "success")
            main.appendBasicBlock(successBlock)
            let getcharReturnValue = builder.buildCall(to: getchar, name: "getcharreturnvalue")
            let getcharReturnedEOF = builder.buildComparison(
                of: getcharReturnValue,
                to: context.makeInt32(0 as UInt32),
                using: .signedLessThan,
                name: "getcharreturnedeof"
            )
            builder.buildBranch(to: failureBlock, if: getcharReturnedEOF, elseTo: successBlock)
            builder.position(atEndOf: successBlock)
            let pointer = builder.buildLoad(from: pointerToPointer, name: "pointer")
            let byte = builder.buildTruncation(of: getcharReturnValue, name: "byte")
            builder.buildStore(of: byte, to: pointer)
        case let .loop(children):
            let bodyBlock = context.makeBasicBlock(name: "body")
            let exitBlock = context.makeBasicBlock(name: "exit")
            main.appendBasicBlock(bodyBlock)
            let pointerBeforeBody = builder.buildLoad(from: pointerToPointer, name: "pointer")
            let byteBeforeBody = builder.buildLoad(from: pointerBeforeBody, name: "byte")
            let byteIsZeroBeforeBody = builder.buildComparison(
                of: byteBeforeBody,
                to: context.makeInt8(0 as UInt8),
                using: .equalTo,
                name: "byteiszero"
            )
            builder.buildBranch(to: exitBlock, if: byteIsZeroBeforeBody, elseTo: bodyBlock)
            builder.position(atEndOf: bodyBlock)
            for child in children {
                child.build(
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
            let pointerAfterBody = builder.buildLoad(from: pointerToPointer, name: "pointer")
            let byteAfterBody = builder.buildLoad(from: pointerAfterBody, name: "byte")
            let byteIsZeroAfterBody = builder.buildComparison(
                of: byteAfterBody,
                to: context.makeInt8(0 as UInt8),
                using: .equalTo,
                name: "byteiszero"
            )
            builder.buildBranch(to: exitBlock, if: byteIsZeroAfterBody, elseTo: bodyBlock)
            builder.position(atEndOf: exitBlock)
        }
    }
}
