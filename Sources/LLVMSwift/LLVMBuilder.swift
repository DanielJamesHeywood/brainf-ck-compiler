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
    
    @inlinable public func buildBranch(to block: LLVMBasicBlock, if condition: LLVMInt1, elseTo elseBlock: LLVMBasicBlock) {
        LLVMBuildCondBr(rawBuilder, condition.rawValue, block.rawBasicBlock, elseBlock.rawBasicBlock)
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
    
    @inlinable public func buildGetElementPointer<Element: LLVMValue>(
        to type: LLVMType<Element>,
        indexing pointer: LLVMPointer<Element>,
        at index: LLVMInt32,
        name: String = "",
        noWrapFlags: [LLVMNoWrapFlag] = []
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
                    noWrapFlags.reduce(0) { rawNoWrapFlags, noWrapFlag in rawNoWrapFlags | noWrapFlag.rawNoWrapFlag }
                )
            )
        }
    }
    
    @inlinable public func buildGetElementPointer<Element: LLVMValue>(
        to type: LLVMType<Element>,
        indexing pointer: LLVMPointer<Element>,
        at index: LLVMInt64,
        name: String = "",
        noWrapFlags: [LLVMNoWrapFlag] = []
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
                    noWrapFlags.reduce(0) { rawNoWrapFlags, noWrapFlag in rawNoWrapFlags | noWrapFlag.rawNoWrapFlag }
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
    
    @inlinable public func buildComparison(of lhs: LLVMInt8, to rhs: LLVMInt8, using predicate: LLVMIntPredicate, name: String = "") -> LLVMInt1 {
        LLVMInt1(rawValue: LLVMBuildICmp(rawBuilder, predicate.rawIntPredicate, lhs.rawValue, rhs.rawValue, name))
    }
    
    @inlinable public func buildComparison(of lhs: LLVMInt32, to rhs: LLVMInt32, using predicate: LLVMIntPredicate, name: String = "") -> LLVMInt1 {
        LLVMInt1(rawValue: LLVMBuildICmp(rawBuilder, predicate.rawIntPredicate, lhs.rawValue, rhs.rawValue, name))
    }
    
    @inlinable @discardableResult public func buildCall<Return: LLVMValue, each Argument: LLVMValue>(
        to function: LLVMFunction<Return, repeat each Argument>,
        passing arguments: repeat each Argument,
        returning returnType: LLVMType<Return>,
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
