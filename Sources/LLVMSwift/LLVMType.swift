import LLVM

public class LLVMType<Value: LLVMValue> {
    
    @usableFromInline let type: LLVMTypeRef
    
    @inlinable required init(type: LLVMTypeRef) {
        self.type = type
    }
}
