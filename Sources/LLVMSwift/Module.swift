import LLVM

public class Module {
    
    @usableFromInline let module: LLVMModuleRef
    
    @inlinable init(name: String, context: Context) {
        self.module = LLVMModuleCreateWithNameInContext(name, context.context)
    }
    
    @inlinable deinit {
        LLVMDisposeModule(module)
    }
}
