import LLVM

public class LLVMInt8: LLVMValue {
    
    @inlinable override class func rawType(in context: LLVMContext) -> LLVMTypeRef {
        LLVMInt8TypeInContext(context.rawContext)
    }
}
