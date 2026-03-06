import LLVM

public class LLVMInt8PointerPointer {
    
    @usableFromInline let value: LLVMValueRef
    
    @inlinable init(value: LLVMValueRef) {
        self.value = value
    }
}
