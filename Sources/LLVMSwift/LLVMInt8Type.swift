import LLVM

public class LLVMInt8Type: LLVMType<LLVMInt8> {
    
    @inlinable convenience init(context: LLVMContext) {
        self.init(rawType: LLVMInt8TypeInContext(context.rawContext))
    }
}
