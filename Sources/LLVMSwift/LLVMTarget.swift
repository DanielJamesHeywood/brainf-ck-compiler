import LLVM

public class LLVMTarget {
    
    @usableFromInline let rawTarget: LLVMTargetRef
    
    @inlinable init(rawTarget: LLVMTargetRef) {
        self.rawTarget = rawTarget
    }
}
