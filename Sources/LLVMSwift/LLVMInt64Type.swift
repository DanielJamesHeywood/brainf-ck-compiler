import LLVM

public class LLVMInt64Type: LLVMType<LLVMInt64> {
    
    @inlinable convenience init(context: LLVMContext) {
        self.init(type: LLVMInt64TypeInContext(context.context))
    }
}
