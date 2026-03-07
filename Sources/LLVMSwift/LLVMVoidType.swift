import LLVM

public class LLVMVoidType: LLVMType<LLVMVoid> {
    
    @inlinable convenience init(context: LLVMContext) {
        self.init(type: LLVMVoidTypeInContext(context.context))
    }
}
