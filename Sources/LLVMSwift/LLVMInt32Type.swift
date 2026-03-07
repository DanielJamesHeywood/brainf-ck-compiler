import LLVM

public class LLVMInt32Type: LLVMType<LLVMInt32> {
    
    @inlinable convenience init(context: LLVMContext) {
        self.init(type: LLVMInt32TypeInContext(context.context))
    }
}
