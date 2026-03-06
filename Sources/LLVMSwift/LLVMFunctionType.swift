import LLVM

public class LLVMFunctionType<Return: LLVMValue, each Parameter: LLVMValue>: LLVMType<LLVMFunction<Return, repeat each Parameter>> {}
