import LLVM

public class LLVMInt32: LLVMValue {
    
    @inlinable public convenience init(_ value: UInt32, type: LLVMInt8Type) {
        self.init(rawValue: LLVMConstInt(type.rawType, UInt64(value), 0))
    }
    
    @inlinable public convenience init(_ value: Int32, type: LLVMInt8Type) {
        self.init(UInt32(bitPattern: value), type: type)
    }
}
