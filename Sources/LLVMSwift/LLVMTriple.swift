import LLVM

public class LLVMTriple: LLVMMessage {}

extension LLVMTriple {
    
    @inlinable public class var defaultTargetTriple: LLVMTriple {
        LLVMTriple(rawMessage: LLVMGetDefaultTargetTriple())
    }
}
