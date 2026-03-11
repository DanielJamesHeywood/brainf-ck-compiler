import LLVM

public class LLVMFunctionType<Return: LLVMValue, each Parameter: LLVMValue>: LLVMType<LLVMFunction<Return, repeat each Parameter>> {
    
    @inlinable public convenience init(returnType: Return, parameterTypes: repeat LLVMType<each Parameter>) {
        var rawParameterTypes = [] as [LLVMTypeRef?]
        for parameterType in repeat each parameterTypes {
            rawParameterTypes.append(parameterType.rawType)
        }
        self.init(
            rawType: rawParameterTypes.withUnsafeMutableBufferPointer { buffer in
                LLVM.LLVMFunctionType(returnType.rawValue, buffer.baseAddress, UInt32(buffer.count), 0)
            }
        )
    }
}
