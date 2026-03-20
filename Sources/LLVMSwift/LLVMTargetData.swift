import LLVM

public class LLVMTargetData {
    
    @usableFromInline let rawTargetData: LLVMTargetDataRef
    
    @inlinable init(rawTargetData: LLVMTargetDataRef) {
        self.rawTargetData = rawTargetData
    }
}
