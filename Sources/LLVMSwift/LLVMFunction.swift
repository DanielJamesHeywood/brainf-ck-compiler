import LLVM

public class LLVMFunction<Return: LLVMValue, each Parameter: LLVMValue>: LLVMValue {
    
    @inlinable override class func rawType(in context: LLVMContext) -> LLVMTypeRef {
        var rawParameterTypes = [] as [LLVMTypeRef?]
        repeat rawParameterTypes.append((each Parameter).rawType(in: context))
        return LLVMFunctionType(Return.rawType(in: context), &rawParameterTypes, UInt32(rawParameterTypes.count), 0)
    }
}

extension LLVMFunction {
    
    @inlinable public func appendBasicBlock(_ block: LLVMBasicBlock) {
        LLVMAppendExistingBasicBlock(rawValue, block.rawBasicBlock)
    }
}
