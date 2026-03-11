import LLVM

public class LLVMArrayType<Element: LLVMValue>: LLVMType<LLVMArray<Element>> {
    
    public typealias ElementCount = Int
    
    @inlinable public convenience init(elementType: LLVMType<Element>, elementCount: ElementCount) {
        self.init(rawType: LLVMArrayType2(elementType.rawType, UInt64(elementCount)))
    }
}

