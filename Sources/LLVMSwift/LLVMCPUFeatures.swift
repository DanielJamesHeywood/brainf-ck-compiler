import LLVM

public class LLVMCPUFeatures: LLVMMessage {}

@inlinable public func makeHostCPUFeatures() -> LLVMCPUFeatures {
    LLVMCPUFeatures(rawMessage: LLVMGetHostCPUFeatures())
}
