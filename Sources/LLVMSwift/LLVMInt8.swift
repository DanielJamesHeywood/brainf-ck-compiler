import LLVM

public class LLVMInt8: LLVMValue {}

extension LLVMInt8 {
    
    @inlinable public convenience init(_ value: UInt8, type: LLVMInt8.LLVMType) {
        self.init(value: LLVMConstInt(type.type, UInt64(value), LLVMBool(false)))
    }
    
    @inlinable public convenience init(_ value: Int8, type: LLVMInt8.LLVMType) {
        self.init(UInt8(bitPattern: value), type: type)
    }
}

extension LLVMInt8.LLVMType {
    
    @inlinable convenience init(context: LLVMContext) {
        self.init(type: LLVMInt8TypeInContext(context.context))
    }
}
