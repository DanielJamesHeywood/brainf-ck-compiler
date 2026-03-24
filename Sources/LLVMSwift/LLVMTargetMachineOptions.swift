import LLVM

public class LLVMTargetMachineOptions {
    
    @usableFromInline let rawOptions: LLVMTargetMachineOptionsRef
    
    @inlinable public init(cpu: LLVMCPUName, features: LLVMCPUFeatures, optimizationLevel: LLVMOptimizationLevel) {
        let rawOptions = LLVMCreateTargetMachineOptions() as LLVMTargetMachineOptionsRef
        LLVMTargetMachineOptionsSetCPU(rawOptions, cpu.rawMessage)
        LLVMTargetMachineOptionsSetFeatures(rawOptions, features.rawMessage)
        LLVMTargetMachineOptionsSetCodeGenOptLevel(rawOptions, optimizationLevel.rawOptimizationLevel)
        self.rawOptions = rawOptions
    }
    
    @inlinable deinit {
        LLVMDisposeTargetMachineOptions(rawOptions)
    }
}
