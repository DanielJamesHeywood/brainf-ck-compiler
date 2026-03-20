import LLVM

public class LLVMCPUName: LLVMMessage {}

@inlinable public func makeHostCPUName() -> LLVMCPUName {
    LLVMCPUName(rawMessage: LLVMGetHostCPUName())
}
