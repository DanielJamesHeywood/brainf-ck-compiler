import LLVM

public class LLVMTargetMachineOptions {
    
    @usableFromInline let rawOptions: LLVMTargetMachineOptionsRef
    
    @inlinable public init(cpu: LLVMCPUName, features: LLVMCPUFeatures) {
        let rawOptions = LLVMCreateTargetMachineOptions() as LLVMTargetMachineOptionsRef
        LLVMTargetMachineOptionsSetCPU(rawOptions, cpu.rawMessage)
        LLVMTargetMachineOptionsSetFeatures(rawOptions, features.rawMessage)
        LLVMTargetMachineOptionsSetCodeGenOptLevel(rawOptions, LLVMCodeGenLevelAggressive)
        self.rawOptions = rawOptions
    }
    
    @inlinable deinit {
        LLVMDisposeTargetMachineOptions(rawOptions)
    }
}
