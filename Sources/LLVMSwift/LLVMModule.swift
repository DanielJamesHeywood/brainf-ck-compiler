import LLVM

public class LLVMModule {
    
    @usableFromInline let module: LLVMModuleRef
    
    @inlinable init(name: String, context: LLVMContext) {
        self.module = LLVMModuleCreateWithNameInContext(name, context.context)
    }
    
    @inlinable deinit {
        LLVMDisposeModule(module)
    }
}
