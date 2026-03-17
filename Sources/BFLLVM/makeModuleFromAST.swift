import BFAbstractSyntaxTree
import LLVMSwift

extension LLVMBuilder {
    
    @inlinable func buildAbstractSyntaxTreeNode(
        _ node: AbstractSyntaxTree.Node,
        in context: LLVMContext,
        putchar: LLVMFunction<LLVMInt32, LLVMInt32>,
        getchar: LLVMFunction<LLVMInt32>,
        main: LLVMFunction<LLVMInt32>,
        pointerToPointer: LLVMPointer<LLVMPointer<LLVMInt8, 0>, 0>,
        pointerToBytes: LLVMPointer<LLVMArray<LLVMInt8, 30000>, 0>
    ) {
        switch node {
        case .incrementPointer:
            let successBlock = context.makeBasicBlock()
            let failureBlock = context.makeBasicBlock()
            main.appendBasicBlock(failureBlock)
            main.appendBasicBlock(successBlock)
            let pointer = buildLoad(from: pointerToPointer)
            let incrementedPointer = buildGetElementPointer(indexing: pointer, at: context.makeInt64(1 as Int64), noWrapFlags: [.inBounds])
            let incrementedPointerIsInBounds = buildComparison(
                of: incrementedPointer,
                to: context.makePointer(
                    indexing: pointerToBytes,
                    at: context.makeInt64(0 as UInt64),
                    thenAt: context.makeInt64(30000 as UInt64),
                    noWrapFlags: [.inBounds]
                ),
                using: .unsignedLessThan
            )
            buildBranch(to: successBlock, if: incrementedPointerIsInBounds, elseTo: failureBlock)
            position(atEndOf: failureBlock)
            buildReturn(of: context.makeInt32(1 as UInt32))
            position(atEndOf: successBlock)
            buildStore(of: incrementedPointer, to: pointerToPointer)
        case .decrementPointer:
            let successBlock = context.makeBasicBlock()
            let failureBlock = context.makeBasicBlock()
            main.appendBasicBlock(failureBlock)
            main.appendBasicBlock(successBlock)
            let pointer = buildLoad(from: pointerToPointer)
            let decrementedPointerWillBeInBounds = buildComparison(
                of: pointer,
                to: context.makePointer(
                    indexing: pointerToBytes,
                    at: context.makeInt64(0 as UInt64),
                    thenAt: context.makeInt64(0 as UInt64),
                    noWrapFlags: [.inBounds]
                ),
                using: .unsignedGreaterThan
            )
            buildBranch(to: successBlock, if: decrementedPointerWillBeInBounds, elseTo: failureBlock)
            position(atEndOf: failureBlock)
            buildReturn(of: context.makeInt32(1 as UInt32))
            position(atEndOf: successBlock)
            let decrementedPointer = buildGetElementPointer(indexing: pointer, at: context.makeInt64(-1 as Int64), noWrapFlags: [.inBounds])
            buildStore(of: decrementedPointer, to: pointerToPointer)
        case .incrementByte:
            let pointer = buildLoad(from: pointerToPointer)
            let byte = buildLoad(from: pointer)
            let incrementedByte = buildAddition(of: context.makeInt8(1 as UInt8), to: byte)
            buildStore(of: incrementedByte, to: pointer)
        case .decrementByte:
            let pointer = buildLoad(from: pointerToPointer)
            let byte = buildLoad(from: pointer)
            let decrementedByte = buildSubtraction(of: context.makeInt8(1 as UInt8), from: byte)
            buildStore(of: decrementedByte, to: pointer)
        case .outputByte:
            let successBlock = context.makeBasicBlock()
            let failureBlock = context.makeBasicBlock()
            main.appendBasicBlock(failureBlock)
            main.appendBasicBlock(successBlock)
            let pointer = buildLoad(from: pointerToPointer)
            let byte = buildLoad(from: pointer)
            let zeroExtendedByte = buildZeroExtension(of: byte)
            let putcharReturnValue = buildCall(to: putchar, passing: zeroExtendedByte)
            let putcharReturnedEOF = buildComparison(of: putcharReturnValue,to: context.makeInt32(0 as UInt32), using: .signedLessThan)
            buildBranch(to: failureBlock, if: putcharReturnedEOF, elseTo: successBlock)
            position(atEndOf: failureBlock)
            buildReturn(of: context.makeInt32(1 as UInt32))
            position(atEndOf: successBlock)
        case .inputByte:
            let successBlock = context.makeBasicBlock()
            let failureBlock = context.makeBasicBlock()
            main.appendBasicBlock(failureBlock)
            main.appendBasicBlock(successBlock)
            let getcharReturnValue = buildCall(to: getchar)
            let getcharReturnedEOF = buildComparison(of: getcharReturnValue, to: context.makeInt32(0 as UInt32), using: .signedLessThan)
            buildBranch(to: failureBlock, if: getcharReturnedEOF, elseTo: successBlock)
            position(atEndOf: failureBlock)
            buildReturn(of: context.makeInt32(1 as UInt32))
            position(atEndOf: successBlock)
            let pointer = buildLoad(from: pointerToPointer)
            let byte = buildTruncation(of: getcharReturnValue)
            buildStore(of: byte, to: pointer)
        case let .loop(children):
            let bodyBlock = context.makeBasicBlock()
            let exitBlock = context.makeBasicBlock()
            main.appendBasicBlock(bodyBlock)
            let pointerBeforeBody = buildLoad(from: pointerToPointer)
            let byteBeforeBody = buildLoad(from: pointerBeforeBody)
            let byteIsZeroBeforeBody = buildComparison(of: byteBeforeBody, to: context.makeInt8(0 as UInt8), using: .equalTo)
            buildBranch(to: exitBlock, if: byteIsZeroBeforeBody, elseTo: bodyBlock)
            position(atEndOf: bodyBlock)
            for child in children {
                buildAbstractSyntaxTreeNode(
                    child,
                    in: context,
                    putchar: putchar,
                    getchar: getchar,
                    main: main,
                    pointerToPointer: pointerToPointer,
                    pointerToBytes: pointerToBytes
                )
            }
            main.appendBasicBlock(exitBlock)
            let pointerAfterBody = buildLoad(from: pointerToPointer)
            let byteAfterBody = buildLoad(from: pointerAfterBody)
            let byteIsZeroAfterBody = buildComparison(of: byteAfterBody, to: context.makeInt8(0 as UInt8), using: .equalTo)
            buildBranch(to: exitBlock, if: byteIsZeroAfterBody, elseTo: bodyBlock)
            position(atEndOf: exitBlock)
        }
    }
}
