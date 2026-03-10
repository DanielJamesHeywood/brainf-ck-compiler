import LLVM

public class LLVMInt64: LLVMValue {
    
    @inlinable public convenience init(_ value: UInt64, type: LLVMInt8Type) {
        self.init(value: LLVMConstInt(type.type, UInt64(value), 0))
    }
    
    @inlinable public convenience init(_ value: Int64, type: LLVMInt8Type) {
        self.init(UInt64(bitPattern: value), type: type)
    }
}
