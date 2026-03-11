import LLVM

public class LLVMType<Value: LLVMValue> {
    
    @usableFromInline let rawType: LLVMTypeRef
    
    @inlinable required init(rawType: LLVMTypeRef) {
        self.rawType = rawType
    }
}
