import LLVM

public class LLVMArray<Element: LLVMValue, let count: LLVMElementCount>: LLVMValue {
    
    @inlinable override class func rawType(in context: LLVMContext) -> LLVMTypeRef {
        LLVMArrayType2(Element.rawType(in: context), UInt64(count))
    }
}
