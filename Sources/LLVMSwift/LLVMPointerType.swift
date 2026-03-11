import LLVM

public class LLVMPointerType<Pointee: LLVMValue>: LLVMType<LLVMPointer<Pointee>> {
    
    public typealias AddressSpace = Int
    
    @inlinable public convenience init(pointeeType: LLVMType<Pointee>, addressSpace: AddressSpace = 0) {
        self.init(type: LLVM.LLVMPointerType(pointeeType.type, UInt32(addressSpace)))
    }
}

