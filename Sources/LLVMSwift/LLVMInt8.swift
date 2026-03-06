import LLVM

public class LLVMInt8 {
    
    @usableFromInline let value: LLVMValueRef
    
    @inlinable init(value: LLVMValueRef) {
        self.value = value
    }
}

extension LLVMInt8 {
    
    @inlinable public convenience init(_ value: UInt8, type: LLVMInt8Type) {
        self.init(value: LLVMConstInt(type.type, UInt64(value), LLVMBool(false)))
    }
    
    @inlinable public convenience init(_ value: Int8, type: LLVMInt8Type) {
        self.init(UInt8(bitPattern: value), type: type)
    }
}
