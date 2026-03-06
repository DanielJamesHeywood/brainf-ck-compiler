import LLVM

public class LLVMInt8 {
    
    @usableFromInline let value: LLVMValueRef
    
    @inlinable init(value: LLVMValueRef) {
        self.value = value
    }
}
