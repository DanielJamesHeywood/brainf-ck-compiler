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
    
    @inlinable public func makeFunction<Return: LLVMValue, each Parameter: LLVMValue>(
        name: String = "",
        type: LLVMFunctionType<Return, repeat each Parameter>
    ) -> LLVMFunction<Return, repeat each Parameter> {
        LLVMFunction(module: self, name: name, type: type)
    }
    
    public typealias AddressSpace = Int
    
    @inlinable public func makeGlobal<Value: LLVMValue>(
        type: LLVMType<Value>,
        name: String = "",
        addressSpace: AddressSpace = 0
    ) -> LLVMPointer<Value> {
        LLVMPointer(rawValue: LLVMAddGlobalInAddressSpace(rawModule, type.rawType, name, UInt32(addressSpace)))
    }
}
