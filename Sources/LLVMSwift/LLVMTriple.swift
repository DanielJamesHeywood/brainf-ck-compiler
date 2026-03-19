import LLVM

public class LLVMTriple: LLVMMessage {}
    
@inlinable public func makeDefaultTargetTriple() -> LLVMTriple {
    LLVMTriple(rawMessage: LLVMGetDefaultTargetTriple())
}

extension LLVMTriple {
    
    @inlinable public func makeTarget() throws(LLVMError) -> LLVMTarget {
        var rawTarget: LLVMTargetRef?
        var rawErrorMessage: UnsafeMutablePointer<CChar>?
        guard LLVMGetTargetFromTriple(rawMessage, &rawTarget, &rawErrorMessage) == 0 else {
            throw LLVMError(LLVMMessage(rawMessage: rawErrorMessage.unsafelyUnwrapped))
        }
        return LLVMTarget(rawTarget: rawTarget.unsafelyUnwrapped)
    }
}
