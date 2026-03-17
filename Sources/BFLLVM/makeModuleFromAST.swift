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
        pointerToBytes: LLVMPointer<LLVMArray<LLVMInt8, 30000>, 0>,
        failureBlock: LLVMBasicBlock
    ) {
        switch node {
        case .incrementPointer:
            let successBlock = context.makeBasicBlock(name: "success")
            main.appendBasicBlock(successBlock)
            let pointer = buildLoad(from: pointerToPointer, name: "pointer")
            let incrementedPointer = buildGetElementPointer(
                indexing: pointer,
                at: context.makeInt64(1 as Int64),
                name: "incrementedpointer",
                noWrapFlags: [.inBounds]
            )
            let incrementedPointerIsInBounds = buildComparison(
                of: incrementedPointer,
                to: context.makePointer(
                    indexing: pointerToBytes,
                    at: context.makeInt64(0 as UInt64),
                    thenAt: context.makeInt64(30000 as UInt64),
                    noWrapFlags: [.inBounds]
                ),
                using: .unsignedLessThan,
                name: "incrementedpointerisinbounds"
            )
            buildBranch(to: successBlock, if: incrementedPointerIsInBounds, elseTo: failureBlock)
            position(atEndOf: successBlock)
            buildStore(of: incrementedPointer, to: pointerToPointer)
        case .decrementPointer:
            let successBlock = context.makeBasicBlock(name: "success")
            main.appendBasicBlock(successBlock)
            let pointer = buildLoad(from: pointerToPointer, name: "pointer")
            let decrementedPointerWillBeInBounds = buildComparison(
                of: pointer,
                to: context.makePointer(
                    indexing: pointerToBytes,
                    at: context.makeInt64(0 as UInt64),
                    thenAt: context.makeInt64(0 as UInt64),
                    noWrapFlags: [.inBounds]
                ),
                using: .unsignedGreaterThan,
                name: "decrementedpointerwillbeinbounds"
            )
            buildBranch(to: successBlock, if: decrementedPointerWillBeInBounds, elseTo: failureBlock)
            position(atEndOf: successBlock)
            let decrementedPointer = buildGetElementPointer(
                indexing: pointer,
                at: context.makeInt64(-1 as Int64),
                name: "decrementedpointer",
                noWrapFlags: [.inBounds]
            )
            buildStore(of: decrementedPointer, to: pointerToPointer)
        case .incrementByte:
            let pointer = buildLoad(from: pointerToPointer, name: "pointer")
            let byte = buildLoad(from: pointer, name: "byte")
            let incrementedByte = buildAddition(of: context.makeInt8(1 as UInt8), to: byte, name: "incrementedbyte")
            buildStore(of: incrementedByte, to: pointer)
        case .decrementByte:
            let pointer = buildLoad(from: pointerToPointer, name: "pointer")
            let byte = buildLoad(from: pointer, name: "byte")
            let decrementedByte = buildSubtraction(of: context.makeInt8(1 as UInt8), from: byte, name: "decrementedbyte")
            buildStore(of: decrementedByte, to: pointer)
        case .outputByte:
            let successBlock = context.makeBasicBlock(name: "success")
            main.appendBasicBlock(successBlock)
            let pointer = buildLoad(from: pointerToPointer, name: "pointer")
            let byte = buildLoad(from: pointer, name: "byte")
            let zeroExtendedByte = buildZeroExtension(of: byte, name: "zeroextendedbyte")
            let putcharReturnValue = buildCall(to: putchar, passing: zeroExtendedByte, name: "putcharreturnvalue")
            let putcharReturnedEOF = buildComparison(
                of: putcharReturnValue,
                to: context.makeInt32(0 as UInt32),
                using: .signedLessThan,
                name: "putcharreturnedeof"
            )
            buildBranch(to: failureBlock, if: putcharReturnedEOF, elseTo: successBlock)
            position(atEndOf: successBlock)
        case .inputByte:
            let successBlock = context.makeBasicBlock(name: "success")
            main.appendBasicBlock(successBlock)
            let getcharReturnValue = buildCall(to: getchar, name: "getcharreturnvalue")
            let getcharReturnedEOF = buildComparison(
                of: getcharReturnValue,
                to: context.makeInt32(0 as UInt32),
                using: .signedLessThan,
                name: "getcharreturnedeof"
            )
            buildBranch(to: failureBlock, if: getcharReturnedEOF, elseTo: successBlock)
            position(atEndOf: successBlock)
            let pointer = buildLoad(from: pointerToPointer, name: "pointer")
            let byte = buildTruncation(of: getcharReturnValue, name: "byte")
            buildStore(of: byte, to: pointer)
        case let .loop(children):
            let bodyBlock = context.makeBasicBlock(name: "body")
            let exitBlock = context.makeBasicBlock(name: "exit")
            main.appendBasicBlock(bodyBlock)
            let pointerBeforeBody = buildLoad(from: pointerToPointer, name: "pointer")
            let byteBeforeBody = buildLoad(from: pointerBeforeBody, name: "byte")
            let byteIsZeroBeforeBody = buildComparison(
                of: byteBeforeBody,
                to: context.makeInt8(0 as UInt8),
                using: .equalTo,
                name: "byteiszero"
            )
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
                    pointerToBytes: pointerToBytes,
                    failureBlock: failureBlock
                )
            }
            main.appendBasicBlock(exitBlock)
            let pointerAfterBody = buildLoad(from: pointerToPointer, name: "pointer")
            let byteAfterBody = buildLoad(from: pointerAfterBody, name: "byte")
            let byteIsZeroAfterBody = buildComparison(
                of: byteAfterBody,
                to: context.makeInt8(0 as UInt8),
                using: .equalTo,
                name: "byteiszero"
            )
            buildBranch(to: exitBlock, if: byteIsZeroAfterBody, elseTo: bodyBlock)
            position(atEndOf: exitBlock)
        }
    }
}
