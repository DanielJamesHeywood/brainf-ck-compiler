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
    
    @inlinable public func buildLoad<Value: LLVMValue>(_ type: LLVMType<Value>, from pointer: LLVMPointer<Value>, name: String = "") -> Value {
        Value(value: LLVMBuildLoad2(builder, type.type, pointer.value, name))
    }
    
    @inlinable public func buildStore<Value: LLVMValue>(_ value: Value, to pointer: LLVMPointer<Value>) {
        LLVMBuildStore(builder, value.value, pointer.value)
    }
}
