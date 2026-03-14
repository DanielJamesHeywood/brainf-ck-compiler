import LLVM

public class LLVMFunction<Return: LLVMValue, each Parameter: LLVMValue>: LLVMValue {}

extension LLVMFunction {
    
    @inlinable public func appendBasicBlock(_ block: LLVMBasicBlock) {
        LLVMAppendExistingBasicBlock(rawValue, block.rawBasicBlock)
    }
}
