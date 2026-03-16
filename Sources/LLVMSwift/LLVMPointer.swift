import LLVM

public class LLVMPointer<Element: LLVMValue, let addressSpace: LLVMAddressSpace>: LLVMValue {
    
    @inlinable override class func rawType(in context: LLVMContext) -> LLVMTypeRef {
        LLVMPointerType(Element.rawType(in: context), UInt32(addressSpace))
    }
}
