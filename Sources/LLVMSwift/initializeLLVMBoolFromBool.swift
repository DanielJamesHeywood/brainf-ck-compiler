import LLVM

extension LLVMBool {
    
    @inlinable init(_ value: Bool) {
        self = value ? 1 : 0
    }
}
