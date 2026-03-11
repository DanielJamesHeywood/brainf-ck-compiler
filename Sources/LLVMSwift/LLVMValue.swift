import LLVM

public class LLVMValue {
    
    @usableFromInline let rawValue: LLVMValueRef
    
    @inlinable required init(rawValue: LLVMValueRef) {
        self.rawValue = rawValue
    }
}
