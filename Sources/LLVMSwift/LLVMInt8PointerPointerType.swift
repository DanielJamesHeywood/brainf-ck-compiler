import LLVM

public class LLVMInt8PointerPointerType {
    
    public typealias AddressSpace = UInt32
    
    @usableFromInline let type: LLVMTypeRef
    
    @inlinable public init(int8PointerType: LLVMInt8PointerType, addressSpace: AddressSpace = 0) {
        self.type = LLVMPointerType(int8PointerType.type, addressSpace)
    }
}
