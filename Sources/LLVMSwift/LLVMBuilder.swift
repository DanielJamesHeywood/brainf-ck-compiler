import LLVM

public class LLVMBuilder {
    
    @usableFromInline let builder: LLVMBuilderRef
    
    @inlinable init(context: LLVMContext) {
        self.builder = LLVMCreateBuilderInContext(context.context)
    }
    
    @inlinable deinit {
        LLVMDisposeBuilder(builder)
    }
}

extension LLVMBuilder {
    
    @inlinable public func buildAdd(_ lhs: LLVMInt8, _ rhs: LLVMInt8, name: String) -> LLVMInt8 {
        LLVMInt8(value: LLVMBuildAdd(builder, lhs.value, rhs.value, name))
    }
}
