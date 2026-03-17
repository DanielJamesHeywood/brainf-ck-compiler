import LLVM

public class LLVMContext {
    
    @usableFromInline let rawContext: LLVMContextRef
    
    @inlinable public init() {
        self.rawContext = LLVMContextCreate()
    }
    
    @inlinable deinit {
        LLVMContextDispose(rawContext)
    }
}

extension LLVMContext {
    
    @inlinable public func makeBasicBlock(name: String = "") -> LLVMBasicBlock {
        LLVMBasicBlock(rawBasicBlock: LLVMCreateBasicBlockInContext(rawContext, name))
    }
    
    @inlinable public func makeBuilder() -> LLVMBuilder {
        LLVMBuilder(context: self)
    }
    
    @inlinable public func makeInt8(_ value: UInt8) -> LLVMInt8 {
        LLVMInt8(rawValue: LLVMConstInt(LLVMInt8.rawType(in: self), UInt64(value), 0))
    }
    
    @inlinable public func makeInt8(_ value: Int8) -> LLVMInt8 {
        makeInt8(UInt8(bitPattern: value))
    }
    
    @inlinable public func makeInt32(_ value: UInt32) -> LLVMInt32 {
        LLVMInt32(rawValue: LLVMConstInt(LLVMInt32.rawType(in: self), UInt64(value), 0))
    }
    
    @inlinable public func makeInt32(_ value: Int32) -> LLVMInt32 {
        makeInt32(UInt32(bitPattern: value))
    }
    
    @inlinable public func makeInt64(_ value: UInt64) -> LLVMInt64 {
        LLVMInt64(rawValue: LLVMConstInt(LLVMInt64.rawType(in: self), value, 0))
    }
    
    @inlinable public func makeInt64(_ value: Int64) -> LLVMInt64 {
        makeInt64(UInt64(bitPattern: value))
    }
    
    @inlinable public func makeModule(name: String = "") -> LLVMModule {
        LLVMModule(context: self, name: name)
    }
    
    @inlinable public func makePointer<Element: LLVMValue, let addressSpace: LLVMAddressSpace, let count: LLVMElementCount>(
        indexing pointerToArray: LLVMPointer<LLVMArray<Element, count>, 0>,
        at pointerIndex: LLVMInt64,
        thenAt arrayIndex: LLVMInt64,
        noWrapFlags: [LLVMNoWrapFlag] = []
    ) -> LLVMPointer<Element, addressSpace> {
        var rawIndices = [pointerIndex.rawValue, arrayIndex.rawValue] as [LLVMValueRef?]
        return LLVMPointer(
            rawValue: rawIndices.withUnsafeMutableBufferPointer { buffer in
                LLVMConstGEPWithNoWrapFlags(
                    Element.rawType(in: self),
                    pointerToArray.rawValue,
                    buffer.baseAddress,
                    UInt32(buffer.count),
                    noWrapFlags.reduce(0) { rawNoWrapFlags, noWrapFlag in rawNoWrapFlags | noWrapFlag.rawNoWrapFlag }
                )
            }
        )
    }
}
