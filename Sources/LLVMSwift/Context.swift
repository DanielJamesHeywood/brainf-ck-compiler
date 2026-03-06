import LLVM

public class Context {
    
    let context = LLVMContextCreate() as LLVMContextRef
    
    deinit {
        LLVMContextDispose(context)
    }
}
