import LLVM

public class LLVMPointer<Pointee: LLVMValue>: LLVMValue {}

extension LLVMPointer {
    
    public typealias AddressSpace = UInt32
    
    @inlinable public static func makeType(pointeeType: Pointee.LLVMType, addressSpace: AddressSpace = 0) -> LLVMType {
        LLVMType(type: LLVMPointerType(pointeeType.type, addressSpace))
    }
}
