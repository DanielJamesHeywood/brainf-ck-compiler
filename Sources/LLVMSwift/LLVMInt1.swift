import LLVM

public class LLVMInt1: LLVMValue {
    
    @inlinable override class func rawType(in context: LLVMContext) -> LLVMTypeRef {
        LLVMInt1TypeInContext(context.rawContext)
    }
}
