import LLVM

public class LLVMBuilder {
    
    @usableFromInline let rawBuilder: LLVMBuilderRef
    
    @inlinable init(rawBuilder: LLVMBuilderRef) {
        self.rawBuilder = rawBuilder
    }
    
    @inlinable deinit {
        LLVMDisposeBuilder(rawBuilder)
    }
}

extension LLVMBuilder {
    
    @inlinable public func buildReturn<Value: LLVMValue>(of value: Value) {
        LLVMBuildRet(rawBuilder, value.rawValue)
    }
    
    @inlinable public func branch(if condition: LLVMInt1, thenTo thenBlock: LLVMBasicBlock, elseTo elseBlock: LLVMBasicBlock) {
        LLVMBuildCondBr(rawBuilder, condition.rawValue, thenBlock.rawBasicBlock, elseBlock.rawBasicBlock)
    }
    
    @inlinable public func buildAddition(of rhs: LLVMInt8, to lhs: LLVMInt8, name: String = "") -> LLVMInt8 {
        LLVMInt8(rawValue: LLVMBuildAdd(rawBuilder, lhs.rawValue, rhs.rawValue, name))
    }
    
    @inlinable public func buildSubtraction(of rhs: LLVMInt8, from lhs: LLVMInt8, name: String = "") -> LLVMInt8 {
        LLVMInt8(rawValue: LLVMBuildSub(rawBuilder, lhs.rawValue, rhs.rawValue, name))
    }
    
    @inlinable public func buildLoad<Value: LLVMValue>(of type: LLVMType<Value>, from pointer: LLVMPointer<Value>, name: String = "") -> Value {
        Value(rawValue: LLVMBuildLoad2(rawBuilder, type.rawType, pointer.rawValue, name))
    }
    
    @inlinable public func buildStore<Value: LLVMValue>(of value: Value, to pointer: LLVMPointer<Value>) {
        LLVMBuildStore(rawBuilder, value.rawValue, pointer.rawValue)
    }
    
    @inlinable public func getElementPointer<Element: LLVMValue>(
        to type: LLVMType<Element>,
        indexing pointer: LLVMPointer<Element>,
        at index: LLVMInt32,
        name: String = "",
        with noWrapFlags: LLVMGEPNoWrapFlags = []
    ) -> LLVMPointer<Element> {
        var rawIndex = index.rawValue as LLVMValueRef?
        return withUnsafeMutablePointer(to: &rawIndex) { pointerToRawIndex in
            LLVMPointer(
                rawValue: LLVMBuildGEPWithNoWrapFlags(
                    rawBuilder,
                    type.rawType,
                    pointer.rawValue,
                    pointerToRawIndex,
                    1,
                    name,
                    UInt32(noWrapFlags.rawValue)
                )
            )
        }
    }
    
    @inlinable public func getElementPointer<Element: LLVMValue>(
        to type: LLVMType<Element>,
        indexing pointer: LLVMPointer<Element>,
        at index: LLVMInt64,
        name: String = "",
        with noWrapFlags: LLVMGEPNoWrapFlags = []
    ) -> LLVMPointer<Element> {
        var rawIndex = index.rawValue as LLVMValueRef?
        return withUnsafeMutablePointer(to: &rawIndex) { pointerToRawIndex in
            LLVMPointer(
                rawValue: LLVMBuildGEPWithNoWrapFlags(
                    rawBuilder,
                    type.rawType,
                    pointer.rawValue,
                    pointerToRawIndex,
                    1,
                    name,
                    UInt32(noWrapFlags.rawValue)
                )
            )
        }
    }
    
    @inlinable public func buildTruncation(of value: LLVMInt32, to type: LLVMInt8Type, name: String = "") -> LLVMInt8 {
        LLVMInt8(rawValue: LLVMBuildTrunc(rawBuilder, value.rawValue, type.rawType, name))
    }
    
    @inlinable public func buildZeroExtension(of value: LLVMInt8, to type: LLVMInt32Type, name: String = "") -> LLVMInt32 {
        LLVMInt32(rawValue: LLVMBuildZExt(rawBuilder, value.rawValue, type.rawType, name))
    }
    
    @inlinable public func compare(using predicate: LLVMPredicate, _ lhs: LLVMInt8, _ rhs: LLVMInt8, name: String = "") -> LLVMInt1 {
        LLVMInt1(rawValue: LLVMBuildICmp(rawBuilder, predicate.toIntPredicate(), lhs.rawValue, rhs.rawValue, name))
    }
    
    @inlinable public func compare(using predicate: LLVMPredicate, _ lhs: LLVMInt32, _ rhs: LLVMInt32, name: String = "") -> LLVMInt1 {
        LLVMInt1(rawValue: LLVMBuildICmp(rawBuilder, predicate.toIntPredicate(), lhs.rawValue, rhs.rawValue, name))
    }
    
    @inlinable @discardableResult public func call<Return: LLVMValue, each Argument: LLVMValue>(
        returning returnType: LLVMType<Return>,
        _ function: LLVMFunction<Return, repeat each Argument>,
        passing arguments: repeat each Argument,
        name: String = ""
    ) -> Return {
        var rawArguments = [] as [LLVMValueRef?]
        for argument in repeat each arguments {
            rawArguments.append(argument.rawValue)
        }
        return rawArguments.withUnsafeMutableBufferPointer { buffer in
            Return(rawValue: LLVMBuildCall2(rawBuilder, returnType.rawType, function.rawValue, buffer.baseAddress, UInt32(buffer.count), name))
        }
    }
}
