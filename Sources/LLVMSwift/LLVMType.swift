import LLVM

public class LLVMType<Value: LLVMValue> {
    
    @usableFromInline let rawType: LLVMTypeRef
    
    @inlinable init(rawType: LLVMTypeRef) {
        self.rawType = rawType
    }
}

extension LLVMType {
    
    @inlinable public func makePointerType<Element: LLVMValue>(addressSpace: LLVMAddressSpace = 0) -> LLVMPointerType<Element> {
        LLVMPointerType(rawType: LLVM.LLVMPointerType(rawType, addressSpace))
    }
}
