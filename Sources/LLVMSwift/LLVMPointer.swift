import LLVM

public class LLVMPointer<Element: LLVMValue>: LLVMValue {
    
    @inlinable public convenience init(
        to type: LLVMType<Element>,
        indexing array: LLVMArray<Element>,
        at index: LLVMInt32,
        noWrapFlags: [LLVMNoWrapFlag] = []
    ) {
        var rawIndex = index.rawValue as LLVMValueRef?
        self.init(
            rawValue: withUnsafeMutablePointer(to: &rawIndex) { pointerToRawIndex in
                LLVMConstGEPWithNoWrapFlags(
                    type.rawType,
                    array.rawValue,
                    pointerToRawIndex,
                    1,
                    noWrapFlags.reduce(0) { rawNoWrapFlags, noWrapFlag in rawNoWrapFlags | noWrapFlag.rawNoWrapFlag }
                )
            }
        )
    }
}
