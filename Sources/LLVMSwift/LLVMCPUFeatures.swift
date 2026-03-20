import LLVM

public class LLVMCPUFeatures: LLVMMessage {}

@inlinable public func makeHostCPUFeatures() -> LLVMCPUName {
    LLVMCPUName(rawMessage: LLVMGetHostCPUFeatures())
}
