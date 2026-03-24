import LLVM
import System

public class LLVMModule {
    
    @usableFromInline let context: LLVMContext
    
    @usableFromInline let rawModule: LLVMModuleRef
    
    @inlinable init(context: LLVMContext, sourceFilePath: FilePath, dataLayout: LLVMTargetData, triple: LLVMTriple, id: String = "") {
        self.context = context
        let rawModule = LLVMModuleCreateWithNameInContext(id, context.rawContext) as LLVMModuleRef
        LLVMSetSourceFileName(rawModule, sourceFilePath.string, sourceFilePath.length)
        LLVMSetModuleDataLayout(rawModule, dataLayout.rawTargetData)
        LLVMSetTarget(rawModule, triple.rawMessage)
        self.rawModule = rawModule
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
        initializingTo value: Value,
        name: String = ""
    ) -> LLVMPointer<Value, addressSpace> {
        let rawGlobal = LLVMAddGlobalInAddressSpace(rawModule, Value.rawType(in: context), name, UInt32(addressSpace)) as LLVMValueRef
        LLVMSetInitializer(rawGlobal, value.rawValue)
        return LLVMPointer(rawValue: rawGlobal)
    }
}

extension LLVMModule {
    
    @inlinable public func print(toFileAt path: FilePath) throws(LLVMError) {
        var rawErrorMessage: UnsafeMutablePointer<CChar>?
        guard LLVMPrintModuleToFile(rawModule, path.string, &rawErrorMessage) == 0 else {
            throw LLVMError(LLVMMessage(rawMessage: rawErrorMessage.unsafelyUnwrapped))
        }
    }
}
