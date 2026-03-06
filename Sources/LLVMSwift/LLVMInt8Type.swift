import LLVM

public class LLVMInt8Type: LLVMType<LLVMValue> {
    
    @inlinable convenience init(context: LLVMContext) {
        self.init(type: LLVMInt8TypeInContext(context.context))
    }
}
