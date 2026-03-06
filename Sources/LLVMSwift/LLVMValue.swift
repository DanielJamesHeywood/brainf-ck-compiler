import LLVM

public class LLVMValue {
    
    public class LLVMType {
        
        @usableFromInline let type: LLVMTypeRef
        
        @inlinable init(type: LLVMTypeRef) {
            self.type = type
        }
    }
    
    @usableFromInline let value: LLVMValueRef
    
    @inlinable init(value: LLVMValueRef) {
        self.value = value
    }
}
