import LLVM

public class LLVMInt8: LLVMValue {
    
    @inlinable public convenience init(_ value: UInt8, type: LLVMInt8Type) {
        self.init(value: LLVMConstInt(type.type, UInt64(value), LLVMBool(false)))
    }
    
    @inlinable public convenience init(_ value: Int8, type: LLVMInt8Type) {
        self.init(UInt8(bitPattern: value), type: type)
    }
}

public class LLVMInt8Type: LLVMType<LLVMValue> {
    
    @inlinable convenience init(context: LLVMContext) {
        self.init(type: LLVMInt8TypeInContext(context.context))
    }
}
