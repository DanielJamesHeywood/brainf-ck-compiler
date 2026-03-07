import LLVM

public class LLVMInt1: LLVMValue {
    
    @inlinable public convenience init(_ value: Bool, type: LLVMInt1Type) {
        self.init(value: LLVMConstInt(type.type, value ? 1 : 0, 0))
    }
}
