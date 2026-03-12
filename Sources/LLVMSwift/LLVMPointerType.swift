import LLVM

public class LLVMPointerType<Element: LLVMValue>: LLVMType<LLVMPointer<Element>> {
    
    public typealias AddressSpace = UInt32
    
    @inlinable public convenience init(elementType: LLVMType<Element>, addressSpace: AddressSpace = 0) {
        self.init(rawType: LLVM.LLVMPointerType(elementType.rawType, addressSpace))
    }
}
