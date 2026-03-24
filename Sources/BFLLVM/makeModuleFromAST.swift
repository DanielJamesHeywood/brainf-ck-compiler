import BFAbstractSyntaxTree
import LLVMSwift
import System

extension LLVMContext {
    
    @inlinable public func makeModule(
        from abstractSyntaxTree: AbstractSyntaxTree,
        sourceFilePath: FilePath,
        dataLayout: LLVMTargetData,
        triple: LLVMTriple,
        id: String = ""
    ) -> LLVMModule {
        let module = makeModule(sourceFilePath: sourceFilePath, dataLayout: dataLayout, triple: triple, id: id)
        let putchar = module.addFunction(name: "putchar") as LLVMFunction<LLVMInt32, LLVMInt32>
        let getchar = module.addFunction(name: "getchar") as LLVMFunction<LLVMInt32>
        let main = module.addFunction(name: "main") as LLVMFunction<LLVMInt32>
        let pointerToBytes = module.addGlobal(initializingTo: makeNull(), name: "pointertobytes") as LLVMPointer<LLVMArray<LLVMInt8, 30000>, 0>
        let pointerToPointer = module.addGlobal(
            initializingTo: makePointer(
                indexing: pointerToBytes,
                at: makeInt64(0 as UInt64),
                thenAt: makeInt64(0 as UInt64),
                noWrapFlags: [.inBounds]
            ),
            name: "pointertopointer"
        ) as LLVMPointer<LLVMPointer<LLVMInt8, 0>, 0>
        let builder = makeBuilder()
        let startBlock = makeBasicBlock()
        main.appendBasicBlock(startBlock)
        builder.position(atEndOf: startBlock)
        for rootNode in abstractSyntaxTree.root {
            builder.buildAbstractSyntaxTreeNode(
                rootNode,
                in: self,
                putchar: putchar,
                getchar: getchar,
                main: main,
                pointerToBytes: pointerToBytes,
                pointerToPointer: pointerToPointer
            )
        }
        builder.buildReturn(of: makeInt32(0 as UInt32))
        return module
    }
}

extension LLVMBuilder {
    
    @inlinable func buildAbstractSyntaxTreeNode(
        _ node: AbstractSyntaxTree.Node,
        in context: LLVMContext,
        putchar: LLVMFunction<LLVMInt32, LLVMInt32>,
        getchar: LLVMFunction<LLVMInt32>,
        main: LLVMFunction<LLVMInt32>,
        pointerToBytes: LLVMPointer<LLVMArray<LLVMInt8, 30000>, 0>,
        pointerToPointer: LLVMPointer<LLVMPointer<LLVMInt8, 0>, 0>
    ) {
        switch node {
        case .incrementPointer:
            let successBlock = context.makeBasicBlock(name: "incrementpointer.success")
            let failureBlock = context.makeBasicBlock(name: "incrementpointer.failure")
            main.appendBasicBlock(failureBlock)
            main.appendBasicBlock(successBlock)
            let pointer = buildLoad(from: pointerToPointer, name: "incrementpointer.pointer")
            let incrementedPointer = buildGetElementPointer(
                indexing: pointer,
                at: context.makeInt64(1 as Int64),
                name: "incrementpointer.incrementedpointer",
                noWrapFlags: [.inBounds]
            )
            let incrementedPointerIsOutOfBounds = buildComparison(
                of: incrementedPointer,
                to: context.makePointer(
                    indexing: pointerToBytes,
                    at: context.makeInt64(0 as UInt64),
                    thenAt: context.makeInt64(30000 as UInt64),
                    noWrapFlags: [.inBounds]
                ),
                using: .unsignedGreaterThanOrEqualTo,
                name: "incrementpointer.incrementedpointerisoutofbounds"
            )
            buildBranch(to: failureBlock, if: incrementedPointerIsOutOfBounds, elseTo: successBlock)
            position(atEndOf: failureBlock)
            buildReturn(of: context.makeInt32(1 as UInt32))
            position(atEndOf: successBlock)
            buildStore(of: incrementedPointer, to: pointerToPointer)
        case .decrementPointer:
            let successBlock = context.makeBasicBlock(name: "decrementpointer.success")
            let failureBlock = context.makeBasicBlock(name: "decrementpointer.failure")
            main.appendBasicBlock(failureBlock)
            main.appendBasicBlock(successBlock)
            let pointer = buildLoad(from: pointerToPointer, name: "decrementpointer.pointer")
            let decrementedPointerWillBeOutOfBounds = buildComparison(
                of: pointer,
                to: context.makePointer(
                    indexing: pointerToBytes,
                    at: context.makeInt64(0 as UInt64),
                    thenAt: context.makeInt64(0 as UInt64),
                    noWrapFlags: [.inBounds]
                ),
                using: .unsignedLessThanOrEqualTo,
                name: "decrementpointer.decrementedpointerwillbeoutofbounds"
            )
            buildBranch(to: failureBlock, if: decrementedPointerWillBeOutOfBounds, elseTo: successBlock)
            position(atEndOf: failureBlock)
            buildReturn(of: context.makeInt32(1 as UInt32))
            position(atEndOf: successBlock)
            let decrementedPointer = buildGetElementPointer(
                indexing: pointer,
                at: context.makeInt64(-1 as Int64),
                name: "decrementpointer.decrementedpointer",
                noWrapFlags: [.inBounds]
            )
            buildStore(of: decrementedPointer, to: pointerToPointer)
        case .incrementByte:
            let pointer = buildLoad(from: pointerToPointer, name: "incrementbyte.pointer")
            let byte = buildLoad(from: pointer, name: "incrementbyte.byte")
            let incrementedByte = buildAddition(of: context.makeInt8(1 as UInt8), to: byte, name: "incrementbyte.incrementedbyte")
            buildStore(of: incrementedByte, to: pointer)
        case .decrementByte:
            let pointer = buildLoad(from: pointerToPointer, name: "decrementbyte.pointer")
            let byte = buildLoad(from: pointer, name: "decrementbyte.byte")
            let decrementedByte = buildSubtraction(of: context.makeInt8(1 as UInt8), from: byte, name: "decrementbyte.decrementedbyte")
            buildStore(of: decrementedByte, to: pointer)
        case .outputByte:
            let successBlock = context.makeBasicBlock(name: "outputbyte.success")
            let failureBlock = context.makeBasicBlock(name: "outputbyte.failure")
            main.appendBasicBlock(failureBlock)
            main.appendBasicBlock(successBlock)
            let pointer = buildLoad(from: pointerToPointer, name: "outputbyte.pointer")
            let byte = buildLoad(from: pointer, name: "outputbyte.byte")
            let zeroExtendedByte = buildZeroExtension(of: byte, name: "outputbyte.zeroextendedbyte")
            let putcharReturnValue = buildCall(to: putchar, passing: zeroExtendedByte, name: "outputbyte.putcharreturnvalue")
            let putcharReturnedEOF = buildComparison(
                of: putcharReturnValue,
                to: context.makeInt32(0 as UInt32),
                using: .signedLessThan,
                name: "outputbyte.putcharreturnedeof"
            )
            buildBranch(to: failureBlock, if: putcharReturnedEOF, elseTo: successBlock)
            position(atEndOf: failureBlock)
            buildReturn(of: context.makeInt32(1 as UInt32))
            position(atEndOf: successBlock)
        case .inputByte:
            let successBlock = context.makeBasicBlock(name: "inputbyte.success")
            let failureBlock = context.makeBasicBlock(name: "inputbyte.failure")
            main.appendBasicBlock(failureBlock)
            main.appendBasicBlock(successBlock)
            let getcharReturnValue = buildCall(to: getchar, name: "inputbyte.getcharreturnvalue")
            let getcharReturnedEOF = buildComparison(
                of: getcharReturnValue,
                to: context.makeInt32(0 as UInt32),
                using: .signedLessThan,
                name: "inputbyte.getcharreturnedeof"
            )
            buildBranch(to: failureBlock, if: getcharReturnedEOF, elseTo: successBlock)
            position(atEndOf: failureBlock)
            buildReturn(of: context.makeInt32(1 as UInt32))
            position(atEndOf: successBlock)
            let pointer = buildLoad(from: pointerToPointer, name: "inputbyte.pointer")
            let byte = buildTruncation(of: getcharReturnValue, name: "inputbyte.byte")
            buildStore(of: byte, to: pointer)
        case let .loop(children):
            let startBlock = context.makeBasicBlock(name: "loop.start")
            let exitBlock = context.makeBasicBlock(name: "loop.exit")
            main.appendBasicBlock(startBlock)
            let pointerBeforeBody = buildLoad(from: pointerToPointer, name: "loop.pointer")
            let byteBeforeBody = buildLoad(from: pointerBeforeBody, name: "loop.byte")
            let byteIsNonZeroBeforeBody = buildComparison(
                of: byteBeforeBody,
                to: context.makeInt8(0 as UInt8),
                using: .notEqualTo,
                name: "loop.byteisnonzero"
            )
            buildBranch(to: startBlock, if: byteIsNonZeroBeforeBody, elseTo: exitBlock)
            position(atEndOf: startBlock)
            for child in children {
                buildAbstractSyntaxTreeNode(
                    child,
                    in: context,
                    putchar: putchar,
                    getchar: getchar,
                    main: main,
                    pointerToBytes: pointerToBytes,
                    pointerToPointer: pointerToPointer
                )
            }
            main.appendBasicBlock(exitBlock)
            let pointerAfterBody = buildLoad(from: pointerToPointer, name: "loop.pointer")
            let byteAfterBody = buildLoad(from: pointerAfterBody, name: "loop.byte")
            let byteIsNonZeroAfterBody = buildComparison(
                of: byteAfterBody,
                to: context.makeInt8(0 as UInt8),
                using: .notEqualTo,
                name: "loop.byteisnonzero"
            )
            buildBranch(to: startBlock, if: byteIsNonZeroAfterBody, elseTo: exitBlock)
            position(atEndOf: exitBlock)
        }
    }
}
