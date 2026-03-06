import LLVM

public class LLVMPointer<Pointee: LLVMValue>: LLVMValue {}

extension LLVMPointer.LLVMType {
    
    public typealias AddressSpace = UInt32
}

extension LLVMPointer {
    
    @inlinable public static func makeType(pointeeType: Pointee.LLVMType, addressSpace: LLVMType.AddressSpace = 0) -> LLVMType {
        LLVMType(type: LLVMPointerType(pointeeType.type, addressSpace))
    }
}
