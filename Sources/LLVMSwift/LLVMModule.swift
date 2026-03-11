import LLVM

public class LLVMModule {
    
    @usableFromInline let rawModule: LLVMModuleRef
    
    @inlinable init(name: String = "", context: LLVMContext) {
        self.rawModule = LLVMModuleCreateWithNameInContext(name, context.rawContext)
    }
    
    @inlinable deinit {
        LLVMDisposeModule(rawModule)
    }
}
