import LLVM

public class LLVMBuilder {
    
    @usableFromInline let context: LLVMContext
    
    @usableFromInline let rawBuilder: LLVMBuilderRef
    
    @inlinable init(context: LLVMContext) {
        self.context = context
        self.rawBuilder = LLVMCreateBuilderInContext(context.rawContext)
    }
    
    @inlinable deinit {
        LLVMDisposeBuilder(rawBuilder)
    }
}

extension LLVMBuilder {
    
    @inlinable public func position(atEndOf block: LLVMBasicBlock) {
        LLVMPositionBuilderAtEnd(rawBuilder, block.rawBasicBlock)
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
    
    @inlinable public func buildLoad<Value: LLVMValue, let addressSpace: LLVMAddressSpace>(
        from pointer: LLVMPointer<Value, addressSpace>,
        name: String = ""
    ) -> Value {
        Value(rawValue: LLVMBuildLoad2(rawBuilder, Value.rawType(in: context), pointer.rawValue, name))
    }
    
    @inlinable public func buildStore<Value: LLVMValue, let addressSpace: LLVMAddressSpace>(
        of value: Value,
        to pointer: LLVMPointer<Value, addressSpace>
    ) {
        LLVMBuildStore(rawBuilder, value.rawValue, pointer.rawValue)
    }
    
    @inlinable public func buildGetElementPointer<Element: LLVMValue, let addressSpace: LLVMAddressSpace>(
        indexing pointer: LLVMPointer<Element, addressSpace>,
        at index: LLVMInt64,
        name: String = "",
        noWrapFlags: [LLVMNoWrapFlag] = []
    ) -> LLVMPointer<Element, addressSpace> {
        var rawIndex = index.rawValue as LLVMValueRef?
        return withUnsafeMutablePointer(to: &rawIndex) { pointerToRawIndex in
            LLVMPointer(
                rawValue: LLVMBuildGEPWithNoWrapFlags(
                    rawBuilder,
                    Element.rawType(in: context),
                    pointer.rawValue,
                    pointerToRawIndex,
                    1,
                    name,
                    noWrapFlags.reduce(0) { rawNoWrapFlags, noWrapFlag in rawNoWrapFlags | noWrapFlag.rawNoWrapFlag }
                )
            )
        }
    }
    
    @inlinable public func buildTruncation(of value: LLVMInt32, name: String = "") -> LLVMInt8 {
        LLVMInt8(rawValue: LLVMBuildTrunc(rawBuilder, value.rawValue, LLVMInt8.rawType(in: context), name))
    }
    
    @inlinable public func buildZeroExtension(of value: LLVMInt8, name: String = "") -> LLVMInt32 {
        LLVMInt32(rawValue: LLVMBuildZExt(rawBuilder, value.rawValue, LLVMInt32.rawType(in: context), name))
    }
    
    @inlinable public func buildComparison(of lhs: LLVMInt8, to rhs: LLVMInt8, using predicate: LLVMIntPredicate, name: String = "") -> LLVMInt1 {
        LLVMInt1(rawValue: LLVMBuildICmp(rawBuilder, predicate.rawIntPredicate, lhs.rawValue, rhs.rawValue, name))
    }
    
    @inlinable public func buildComparison(of lhs: LLVMInt32, to rhs: LLVMInt32, using predicate: LLVMIntPredicate, name: String = "") -> LLVMInt1 {
        LLVMInt1(rawValue: LLVMBuildICmp(rawBuilder, predicate.rawIntPredicate, lhs.rawValue, rhs.rawValue, name))
    }
    
    @inlinable public func buildComparison<Element: LLVMValue, let addressSpace: LLVMAddressSpace>(
        of lhs: LLVMPointer<Element, addressSpace>,
        to rhs: LLVMPointer<Element, addressSpace>,
        using predicate: LLVMIntPredicate,
        name: String = ""
    ) -> LLVMInt1 {
        LLVMInt1(rawValue: LLVMBuildICmp(rawBuilder, predicate.rawIntPredicate, lhs.rawValue, rhs.rawValue, name))
    }
    
    @inlinable @discardableResult public func buildCall<Return: LLVMValue, each Argument: LLVMValue>(
        to function: LLVMFunction<Return, repeat each Argument>,
        passing arguments: repeat each Argument,
        name: String = ""
    ) -> Return {
        var rawArguments = [] as [LLVMValueRef?]
        repeat rawArguments.append((each arguments).rawValue)
        return rawArguments.withUnsafeMutableBufferPointer { buffer in
            Return(
                rawValue: LLVMBuildCall2(rawBuilder, Return.rawType(in: context), function.rawValue, buffer.baseAddress, UInt32(buffer.count), name)
            )
        }
    }
}
