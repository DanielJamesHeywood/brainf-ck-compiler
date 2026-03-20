import LLVM

public class LLVMTriple: LLVMMessage {}
    
@inlinable public func makeDefaultTargetTriple() -> LLVMTriple {
    LLVMTriple(rawMessage: LLVMGetDefaultTargetTriple())
}
