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
    
    @inlinable public func buildAdd(_ lhs: LLVMInt8, _ rhs: LLVMInt8, name: String = "") -> LLVMInt8 {
        LLVMInt8(value: LLVMBuildAdd(builder, lhs.value, rhs.value, name))
    }
    
    @inlinable public func buildSubtract(_ lhs: LLVMInt8, _ rhs: LLVMInt8, name: String = "") -> LLVMInt8 {
        LLVMInt8(value: LLVMBuildSub(builder, lhs.value, rhs.value, name))
    }
    
    @inlinable public func buildLoad(_ type: LLVMInt8Type, from pointer: LLVMInt8Pointer, name: String = "") -> LLVMInt8 {
        LLVMInt8(value: LLVMBuildLoad2(builder, type.type, pointer.value, name))
    }
    
    @inlinable public func buildLoad(_ type: LLVMInt8PointerType, from pointer: LLVMInt8PointerPointer, name: String = "") -> LLVMInt8Pointer {
        LLVMInt8Pointer(value: LLVMBuildLoad2(builder, type.type, pointer.value, name))
    }
    
    @inlinable public func buildStore(_ value: LLVMInt8, to pointer: LLVMInt8Pointer) {
        LLVMBuildStore(builder, value.value, pointer.value)
    }
}
