import LLVM

public class LLVMTriple: LLVMMessage {
    
    @inlinable public class var defaultTargetTriple: LLVMTriple {
        LLVMTriple(rawMessage: LLVMGetDefaultTargetTriple())
    }
}
