import LLVM

public class LLVMArrayType<Element: LLVMValue, let count: LLVMElementCount>: LLVMType<LLVMArray<Element, count>> {
    
    @inlinable public convenience init(elementType: LLVMType<Element>) {
        self.init(rawType: LLVMArrayType2(elementType.rawType, UInt64(count)))
    }
}
