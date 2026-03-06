import LLVM

public class Context {
    
    @usableFromInline let context = LLVMContextCreate() as LLVMContextRef
    
    @inlinable deinit {
        LLVMContextDispose(context)
    }
}
