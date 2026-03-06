import LLVM

public class LLVMValue {
    
    @usableFromInline let value: LLVMValueRef
    
    @inlinable required init(value: LLVMValueRef) {
        self.value = value
    }
}
