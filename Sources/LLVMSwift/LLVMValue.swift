import LLVM

public class LLVMValue {
    
    public class LLVMType {
        
        @usableFromInline let type: LLVMTypeRef
        
        @inlinable required init(type: LLVMTypeRef) {
            self.type = type
        }
    }
    
    @usableFromInline let value: LLVMValueRef
    
    @inlinable required init(value: LLVMValueRef) {
        self.value = value
    }
}
