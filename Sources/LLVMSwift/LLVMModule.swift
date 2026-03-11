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

extension LLVMModule {
    
    @inlinable public func makeFunction<Return: LLVMValue, each Parameter: LLVMValue>(
        name: String = "",
        type: LLVMFunctionType<Return, repeat each Parameter>
    ) -> LLVMFunction<Return, repeat each Parameter> {
        LLVMFunction(module: self, name: name, type: type)
    }
}
