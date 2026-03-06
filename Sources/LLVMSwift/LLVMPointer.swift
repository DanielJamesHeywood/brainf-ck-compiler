import LLVM

public class LLVMPointer {
    
    public class LLVMType {
        
        public typealias AddressSpace = UInt32
        
        @usableFromInline let type: LLVMTypeRef
        
        @inlinable public init(pointeeType: LLVMValue.LLVMType, addressSpace: AddressSpace = 0) {
            self.type = LLVMPointerType(pointeeType.type, addressSpace)
        }
    }
    
    @usableFromInline let value: LLVMValueRef
    
    @inlinable init(value: LLVMValueRef) {
        self.value = value
    }
}
