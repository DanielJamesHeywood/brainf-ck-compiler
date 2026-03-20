import LLVM

public class LLVMTargetMachineOptions {
    
    @usableFromInline let rawOptions: LLVMTargetMachineOptionsRef
    
    @inlinable public init() {
        self.rawOptions = LLVMCreateTargetMachineOptions()
    }
    
    @inlinable deinit {
        LLVMDisposeTargetMachineOptions(rawOptions)
    }
}
