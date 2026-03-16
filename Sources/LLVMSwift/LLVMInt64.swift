import LLVM

public class LLVMInt64: LLVMValue {
    
    @inlinable override class func rawType(in context: LLVMContext) -> LLVMTypeRef {
        LLVMInt64TypeInContext(context.rawContext)
    }
}
