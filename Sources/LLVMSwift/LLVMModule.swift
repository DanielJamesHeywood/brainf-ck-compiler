import LLVM

public class LLVMModule {
    
    @usableFromInline let rawModule: LLVMModuleRef
    
    @inlinable init(rawModule: LLVMModuleRef) {
        self.rawModule = rawModule
    }
    
    @inlinable deinit {
        LLVMDisposeModule(rawModule)
    }
}

extension LLVMModule {
    
    @inlinable public func addFunction<Return: LLVMValue, each Parameter: LLVMValue>(
        type: LLVMFunctionType<Return, repeat each Parameter>,
        name: String = ""
    ) -> LLVMFunction<Return, repeat each Parameter> {
        LLVMFunction(rawValue: LLVMAddFunction(rawModule, name, type.rawType))
    }
    
    public typealias AddressSpace = UInt32
    
    @inlinable public func addGlobal<Value: LLVMValue>(
        type: LLVMType<Value>,
        name: String = "",
        addressSpace: AddressSpace = 0
    ) -> LLVMPointer<Value> {
        LLVMPointer(rawValue: LLVMAddGlobalInAddressSpace(rawModule, type.rawType, name, addressSpace))
    }
}
