import LLVM

public class LLVMTarget {
    
    @usableFromInline let rawTarget: LLVMTargetRef
    
    @inlinable init(rawTarget: LLVMTargetRef) {
        self.rawTarget = rawTarget
    }
}

extension LLVMTarget {
    
    @inlinable public convenience init(triple: LLVMTriple) throws(LLVMError) {
        var rawTarget: LLVMTargetRef?
        var rawErrorMessage: UnsafeMutablePointer<CChar>?
        guard LLVMGetTargetFromTriple(triple.rawMessage, &rawTarget, &rawErrorMessage) == 0 else {
            throw LLVMError(LLVMMessage(rawMessage: rawErrorMessage.unsafelyUnwrapped))
        }
        self.init(rawTarget: rawTarget.unsafelyUnwrapped)
    }
}
