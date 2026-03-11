import LLVM

public class LLVMBuilder {
    
    @usableFromInline let rawBuilder: LLVMBuilderRef
    
    @inlinable init(context: LLVMContext) {
        self.rawBuilder = LLVMCreateBuilderInContext(context.rawContext)
    }
    
    @inlinable deinit {
        LLVMDisposeBuilder(rawBuilder)
    }
}

extension LLVMBuilder {
    
    @inlinable public func `return`<Value: LLVMValue>(_ value: Value) {
        LLVMBuildRet(rawBuilder, value.rawValue)
    }
    
    @inlinable public func add(_ lhs: LLVMInt8, _ rhs: LLVMInt8, name: String = "") -> LLVMInt8 {
        LLVMInt8(rawValue: LLVMBuildAdd(rawBuilder, lhs.rawValue, rhs.rawValue, name))
    }
    
    @inlinable public func subtract(_ lhs: LLVMInt8, _ rhs: LLVMInt8, name: String = "") -> LLVMInt8 {
        LLVMInt8(rawValue: LLVMBuildSub(rawBuilder, lhs.rawValue, rhs.rawValue, name))
    }
    
    @inlinable public func load<Value: LLVMValue>(_ type: LLVMType<Value>, from pointer: LLVMPointer<Value>, name: String = "") -> Value {
        Value(rawValue: LLVMBuildLoad2(rawBuilder, type.rawType, pointer.rawValue, name))
    }
    
    @inlinable public func store<Value: LLVMValue>(_ value: Value, to pointer: LLVMPointer<Value>) {
        LLVMBuildStore(rawBuilder, value.rawValue, pointer.rawValue)
    }
    
    @inlinable public func getElementPointer<Element: LLVMValue>(
        to type: LLVMType<Element>,
        indexing pointer: LLVMPointer<Element>,
        at index: LLVMInt32,
        with noWrapFlags: LLVMGEPNoWrapFlags = [],
        name: String = ""
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
        with noWrapFlags: LLVMGEPNoWrapFlags = [],
        name: String = ""
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
    
    @inlinable public func truncate(_ value: LLVMInt32, to type: LLVMInt8Type, name: String = "") -> LLVMInt8 {
        LLVMInt8(rawValue: LLVMBuildTrunc(rawBuilder, value.rawValue, type.rawType, name))
    }
    
    @inlinable public func zeroExtend(_ value: LLVMInt8, to type: LLVMInt32Type, name: String = "") -> LLVMInt32 {
        LLVMInt32(rawValue: LLVMBuildZExt(rawBuilder, value.rawValue, type.rawType, name))
    }
    
    @inlinable public func compare(using predicate: LLVMPredicate, _ lhs: LLVMInt8, _ rhs: LLVMInt8, name: String = "") -> LLVMInt1 {
        LLVMInt1(rawValue: LLVMBuildICmp(rawBuilder, predicate.toIntPredicate(), lhs.rawValue, rhs.rawValue, name))
    }
    
    @inlinable public func compare(using predicate: LLVMPredicate, _ lhs: LLVMInt32, _ rhs: LLVMInt32, name: String = "") -> LLVMInt1 {
        LLVMInt1(rawValue: LLVMBuildICmp(rawBuilder, predicate.toIntPredicate(), lhs.rawValue, rhs.rawValue, name))
    }
    
    @inlinable @discardableResult public func call<Return: LLVMValue, each Argument: LLVMValue>(
        _ function: LLVMFunction<Return, repeat each Argument>,
        returning returnType: LLVMType<Return>,
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
