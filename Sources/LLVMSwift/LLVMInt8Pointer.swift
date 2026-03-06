import LLVM

public class LLVMInt8Pointer {
    
    @usableFromInline let value: LLVMValueRef
    
    @inlinable init(value: LLVMValueRef) {
        self.value = value
    }
}
