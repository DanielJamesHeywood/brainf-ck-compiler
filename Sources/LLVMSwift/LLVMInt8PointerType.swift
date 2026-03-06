import LLVM

public class LLVMInt8PointerType {
    
    public typealias AddressSpace = UInt32
    
    @usableFromInline let type: LLVMTypeRef
    
    @inlinable public init(int8Type: LLVMInt8Type, addressSpace: AddressSpace = 0) {
        self.type = LLVMPointerType(int8Type.type, addressSpace)
    }
}
