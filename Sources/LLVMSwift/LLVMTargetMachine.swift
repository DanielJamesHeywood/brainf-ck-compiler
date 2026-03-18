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
    
    @inlinable public init(target: LLVMTarget, triple: LLVMMessage, options: Options) {
        self.rawTargetMachine = LLVMCreateTargetMachineWithOptions(target.rawTarget, triple.rawMessage, options.rawOptions)
    }
    
    @inlinable deinit {
        LLVMDisposeTargetMachine(rawTargetMachine)
    }
}
