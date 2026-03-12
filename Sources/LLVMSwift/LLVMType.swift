import LLVM

public class LLVMType<Value: LLVMValue> {
    
    @usableFromInline let rawType: LLVMTypeRef
    
    @inlinable init(rawType: LLVMTypeRef) {
        self.rawType = rawType
    }
}
