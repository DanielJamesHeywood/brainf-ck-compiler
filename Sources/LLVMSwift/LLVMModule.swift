import LLVM

public class LLVMModule {
    
    @usableFromInline let context: LLVMContext
    
    @usableFromInline let rawModule: LLVMModuleRef
    
    @inlinable init(context: LLVMContext, name: String = "") {
        self.context = context
        self.rawModule = LLVMModuleCreateWithNameInContext(name, context.rawContext)
    }
    
    @inlinable deinit {
        LLVMDisposeModule(rawModule)
    }
}

extension LLVMModule {
    
    @inlinable public func addFunction<Return: LLVMValue, each Parameter: LLVMValue>(
        name: String = ""
    ) -> LLVMFunction<Return, repeat each Parameter> {
        LLVMFunction(rawValue: LLVMAddFunction(rawModule, name, LLVMFunction<Return, repeat each Parameter>.rawType(in: context)))
    }
    
    @inlinable public func addGlobal<Value: LLVMValue, let addressSpace: LLVMAddressSpace>(
        name: String = "",
        initializingTo value: Value
    ) -> LLVMPointer<Value, addressSpace> {
        let rawGlobal = LLVMAddGlobalInAddressSpace(rawModule, Value.rawType(in: context), name, UInt32(addressSpace)) as LLVMValueRef
        LLVMSetInitializer(rawGlobal, value.rawValue)
        return LLVMPointer(rawValue: rawGlobal)
    }
}
