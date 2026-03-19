
public struct LLVMError: Error {
    
    @usableFromInline let messageDescription: String
    
    @inlinable init(_ message: LLVMMessage) {
        self.messageDescription = String(cString: message.rawMessage)
    }
}

extension LLVMError: CustomStringConvertible {
    
    @inlinable public var description: String {
        messageDescription
    }
}
