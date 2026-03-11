import LLVM

public class LLVMFunction<Return: LLVMValue, each Parameter: LLVMValue>: LLVMValue {
    
    @inlinable convenience init(module: LLVMModule, name: String = "", type: LLVMFunctionType<Return, repeat each Parameter>) {
        self.init(rawValue: LLVMAddFunction(module.rawModule, name, type.rawType))
    }
}
