import LLVM

public class LLVMInt8 {
    
    public class LLVMType {
        
        @usableFromInline let type: LLVMTypeRef
        
        @inlinable init(context: LLVMContext) {
            self.type = LLVMInt8TypeInContext(context.context)
        }
    }
    
    @usableFromInline let value: LLVMValueRef
    
    @inlinable init(value: LLVMValueRef) {
        self.value = value
    }
}

extension LLVMInt8 {
    
    @inlinable public convenience init(_ value: UInt8, type: LLVMInt8.LLVMType) {
        self.init(value: LLVMConstInt(type.type, UInt64(value), LLVMBool(false)))
    }
    
    @inlinable public convenience init(_ value: Int8, type: LLVMInt8.LLVMType) {
        self.init(UInt8(bitPattern: value), type: type)
    }
}
