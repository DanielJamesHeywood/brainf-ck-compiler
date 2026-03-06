import LLVM

public class LLVMInt8Type {
    
    @usableFromInline let type: LLVMTypeRef
    
    @inlinable init(context: LLVMContext) {
        self.type = LLVMInt8TypeInContext(context.context)
    }
}
