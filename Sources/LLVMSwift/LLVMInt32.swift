import LLVM

public class LLVMInt32: LLVMValue {
    
    @inlinable override class func rawType(in context: LLVMContext) -> LLVMTypeRef {
        LLVMInt32TypeInContext(context.rawContext)
    }
}
