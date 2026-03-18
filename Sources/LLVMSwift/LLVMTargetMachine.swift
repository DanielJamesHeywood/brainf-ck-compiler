import LLVM

public class LLVMTargetMachine {
    
    public class Options {
        
        @usableFromInline let rawOptions: LLVMTargetMachineOptionsRef
        
        @inlinable init() {
            self.rawOptions = LLVMCreateTargetMachineOptions()
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
