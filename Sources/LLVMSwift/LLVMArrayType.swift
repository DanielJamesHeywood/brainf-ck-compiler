import LLVM

public class LLVMArrayType<Element: LLVMValue>: LLVMType<LLVMArray<Element>> {
    
    public typealias ElementCount = UInt64
    
    @inlinable public convenience init(elementType: LLVMType<Element>, elementCount: ElementCount) {
        self.init(rawType: LLVMArrayType2(elementType.rawType, elementCount))
    }
}
