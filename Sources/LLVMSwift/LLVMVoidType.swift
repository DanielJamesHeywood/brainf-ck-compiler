import LLVM

public class LLVMVoidType: LLVMType<LLVMValue> {
    
    @inlinable convenience init(context: LLVMContext) {
        self.init(type: LLVMVoidTypeInContext(context.context))
    }
}
