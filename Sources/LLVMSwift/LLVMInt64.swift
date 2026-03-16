import LLVM

public class LLVMInt64: LLVMValue {
    
    @inlinable public convenience init(_ value: UInt64, type: LLVMInt64Type) {
        self.init(rawValue: LLVMConstInt(type.rawType, UInt64(value), 0))
    }
    
    @inlinable public convenience init(_ value: Int64, type: LLVMInt64Type) {
        self.init(UInt64(bitPattern: value), type: type)
    }
}
