import LLVM

public class LLVMContext {
    
    @usableFromInline let rawContext: LLVMContextRef
    
    @inlinable public init() {
        self.rawContext = LLVMContextCreate()
    }
    
    @inlinable deinit {
        LLVMContextDispose(rawContext)
    }
}

extension LLVMContext {
    
    @inlinable public func appendBasicBlock<Return: LLVMValue, each Parameter: LLVMValue>(
        to function: LLVMFunction<Return, repeat each Parameter>,
        name: String = ""
    ) -> LLVMBasicBlock {
        LLVMBasicBlock(rawBasicBlock: LLVMAppendBasicBlockInContext(rawContext, function.rawValue, name))
    }
    
    @inlinable public func makeBasicBlock(name: String = "") -> LLVMBasicBlock {
        LLVMBasicBlock(rawBasicBlock: LLVMCreateBasicBlockInContext(rawContext, name))
    }
    
    @inlinable public func makeBuilder() -> LLVMBuilder {
        LLVMBuilder(rawBuilder: LLVMCreateBuilderInContext(rawContext))
    }
    
    @inlinable public func makeInt8Type() -> LLVMInt8Type {
        LLVMInt8Type(rawType: LLVMInt8TypeInContext(rawContext))
    }
    
    @inlinable public func makeInt32Type() -> LLVMInt32Type {
        LLVMInt32Type(rawType: LLVMInt32TypeInContext(rawContext))
    }
    
    @inlinable public func makeInt64Type() -> LLVMInt64Type {
        LLVMInt64Type(rawType: LLVMInt64TypeInContext(rawContext))
    }
    
    @inlinable public func makeModule(id: String = "") -> LLVMModule {
        LLVMModule(rawModule: LLVMModuleCreateWithNameInContext(id, rawContext))
    }
}
