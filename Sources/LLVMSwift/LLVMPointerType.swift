import LLVM

public class LLVMPointerType<Pointee: LLVMValue>: LLVMType<LLVMPointer<Pointee>> {
    
    public typealias AddressSpace = Int
    
    @inlinable public convenience init(pointeeType: LLVMType<Pointee>, addressSpace: AddressSpace = 0) {
        self.init(rawType: LLVM.LLVMPointerType(pointeeType.rawType, UInt32(addressSpace)))
    }
}
