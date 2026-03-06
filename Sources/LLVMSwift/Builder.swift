import LLVM

public class Builder {
    
    @usableFromInline let builder: LLVMBuilderRef
    
    @inlinable init(context: Context) {
        self.builder = LLVMCreateBuilderInContext(context.context)
    }
    
    @inlinable deinit {
        LLVMDisposeBuilder(builder)
    }
}
