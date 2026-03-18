import LLVM

public class LLVMTargetMachine {
    
    @usableFromInline let rawTargetMachine: LLVMTargetMachineRef
    
    @inlinable public init(rawTargetMachine: LLVMTargetMachineRef) {
        self.rawTargetMachine = rawTargetMachine
    }
    
    @inlinable deinit {
        LLVMDisposeTargetMachine(rawTargetMachine)
    }
}
