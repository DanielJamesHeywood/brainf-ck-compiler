import LLVM

public class LLVMBasicBlock {
    
    @usableFromInline let rawBasicBlock: LLVMBasicBlockRef
    
    @inlinable init(rawBasicBlock: LLVMBasicBlockRef) {
        self.rawBasicBlock = rawBasicBlock
    }
}
