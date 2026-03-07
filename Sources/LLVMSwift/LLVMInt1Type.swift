import LLVM

public class LLVMInt1Type: LLVMType<LLVMInt1> {
    
    @inlinable convenience init(context: LLVMContext) {
        self.init(type: LLVMInt1TypeInContext(context.context))
    }
}
