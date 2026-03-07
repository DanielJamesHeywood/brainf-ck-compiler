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
    
    @inlinable public func buildAdd(
        _ lhs: LLVMInt8, _ rhs: LLVMInt8,
        name: String = ""
    ) -> LLVMInt8 {
        LLVMInt8(value: LLVMBuildAdd(builder, lhs.value, rhs.value, name))
    }
    
    @inlinable public func buildSubtract(
        _ lhs: LLVMInt8, _ rhs: LLVMInt8,
        name: String = ""
    ) -> LLVMInt8 {
        LLVMInt8(value: LLVMBuildSub(builder, lhs.value, rhs.value, name))
    }
    
    @inlinable public func buildLoad<Value: LLVMValue>(
        type: LLVMType<Value>,
        from pointer: LLVMPointer<Value>,
        name: String = ""
    ) -> Value {
        Value(value: LLVMBuildLoad2(builder, type.type, pointer.value, name))
    }
    
    @inlinable public func buildStore<Value: LLVMValue>(
        _ value: Value,
        to pointer: LLVMPointer<Value>
    ) {
        LLVMBuildStore(builder, value.value, pointer.value)
    }
    
    @inlinable public func buildTruncate(
        _ value: LLVMInt32,
        to type: LLVMInt8Type,
        name: String = ""
    ) -> LLVMInt8 {
        LLVMInt8(value: LLVMBuildTrunc(builder, value.value, type.type, name))
    }
    
    @inlinable public func buildZeroExtend(
        _ value: LLVMInt8,
        to type: LLVMInt32Type,
        name: String = ""
    ) -> LLVMInt8 {
        LLVMInt8(value: LLVMBuildZExt(builder, value.value, type.type, name))
    }
    
    @inlinable @discardableResult public func buildCall<Return: LLVMValue, each Argument: LLVMValue>(
        returnType: LLVMType<Return>,
        function: LLVMFunction<Return, repeat each Argument>,
        arguments: repeat each Argument,
        name: String = ""
    ) -> Return {
        var argumentValues = [] as [LLVMValueRef?]
        for argument in repeat each arguments {
            argumentValues.append(argument.value)
        }
        return argumentValues.withUnsafeMutableBufferPointer { buffer in
            Return(value: LLVMBuildCall2(builder, returnType.type, function.value, buffer.baseAddress, UInt32(buffer.count), name))
        }
    }
}
