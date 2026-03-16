import LLVM

public class LLVMValue {
    
    @usableFromInline let rawValue: LLVMValueRef
    
    @inlinable required init(rawValue: LLVMValueRef) {
        self.rawValue = rawValue
    }
    
    @inlinable class func rawType(in context: LLVMContext) -> LLVMTypeRef {
        preconditionFailure("LLVMValue does not have a raw type")
    }
}
