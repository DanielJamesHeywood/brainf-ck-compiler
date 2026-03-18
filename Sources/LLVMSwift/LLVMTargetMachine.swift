import LLVM

public class LLVMTargetMachine {
    
    public class Options {
        
        @usableFromInline let rawOptions: LLVMTargetMachineOptionsRef
        
        @inlinable init(rawOptions: LLVMTargetMachineOptionsRef) {
            self.rawOptions = rawOptions
        }
        
        @inlinable deinit {
            LLVMDisposeTargetMachineOptions(rawOptions)
        }
    }
    
    @usableFromInline let rawTargetMachine: LLVMTargetMachineRef
    
    @inlinable public init(rawTargetMachine: LLVMTargetMachineRef) {
        self.rawTargetMachine = rawTargetMachine
    }
    
    @inlinable deinit {
        LLVMDisposeTargetMachine(rawTargetMachine)
    }
}
