import LLVM

public class LLVMPointerType<Element: LLVMValue>: LLVMType<LLVMPointer<Element>> {
    
    @inlinable public convenience init(elementType: LLVMType<Element>, addressSpace: LLVMAddressSpace = 0) {
        self.init(rawType: LLVM.LLVMPointerType(elementType.rawType, addressSpace))
    }
}
