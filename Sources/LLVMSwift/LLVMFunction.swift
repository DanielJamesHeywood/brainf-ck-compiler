import LLVM

public class LLVMFunction<Return: LLVMValue, each Parameter: LLVMValue>: LLVMValue {
    
    @inlinable override class func rawType(in context: LLVMContext) -> LLVMTypeRef {
        var rawParameterTypes = [] as [LLVMTypeRef?]
        repeat rawParameterTypes.append((each Parameter).rawType(in: context))
        return rawParameterTypes.withUnsafeMutableBufferPointer { buffer in
            LLVMFunctionType(Return.rawType(in: context), buffer.baseAddress, UInt32(buffer.count), 0)
        }
    }
}

extension LLVMFunction {
    
    @inlinable public func appendBasicBlock(_ block: LLVMBasicBlock) {
        LLVMAppendExistingBasicBlock(rawValue, block.rawBasicBlock)
    }
}
