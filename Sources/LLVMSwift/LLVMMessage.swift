import LLVM

public class LLVMMessage {
    
    @usableFromInline let rawMessage: UnsafeMutablePointer<CChar>
    
    @inlinable init(rawMessage: UnsafeMutablePointer<CChar>) {
        self.rawMessage = rawMessage
    }
    
    @inlinable deinit {
        LLVMDisposeMessage(rawMessage)
    }
}

extension LLVMMessage: CustomStringConvertible {
    
    @inlinable public var description: String {
        String(cString: rawMessage)
    }
}
