import LLVM

public class LLVMInt8PointerType {
    
    public typealias AddressSpace = UInt32
    
    @usableFromInline let type: LLVMTypeRef
    
    @inlinable public init(pointeeType: LLVMInt8Type, addressSpace: AddressSpace = 0) {
        self.type = LLVMPointerType(pointeeType.type, addressSpace)
    }
}
