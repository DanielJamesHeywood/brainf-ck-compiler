import LLVM

public class LLVMPointer<Pointee: LLVMValue>: LLVMValue {}

public class LLVMPointerType<Pointee: LLVMValue>: LLVMType<LLVMPointer<Pointee>> {
    
    public typealias AddressSpace = UInt32
    
    @inlinable public convenience init(pointeeType: LLVMType<Pointee>, addressSpace: AddressSpace = 0) {
        self.init(type: LLVM.LLVMPointerType(pointeeType.type, addressSpace))
    }
}
