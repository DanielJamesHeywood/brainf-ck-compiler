import LLVM

public class LLVMContext {
    
    @usableFromInline let context = LLVMContextCreate() as LLVMContextRef
    
    @inlinable deinit {
        LLVMContextDispose(context)
    }
}

extension LLVMContext {
    
    @inlinable public func makeBuilder() -> LLVMBuilder {
        LLVMBuilder(context: self)
    }
    
    @inlinable public func makeModule(name: String) -> LLVMModule {
        LLVMModule(name: name, context: self)
    }
}
