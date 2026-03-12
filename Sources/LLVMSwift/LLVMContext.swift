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
    
    @inlinable public func makeBuilder() -> LLVMBuilder {
        LLVMBuilder(context: self)
    }
    
    @inlinable public func makeInt8Type() -> LLVMInt8Type {
        LLVMInt8Type(context: self)
    }
    
    @inlinable public func makeInt32Type() -> LLVMInt32Type {
        LLVMInt32Type(context: self)
    }
    
    @inlinable public func makeInt64Type() -> LLVMInt64Type {
        LLVMInt64Type(context: self)
    }
    
    @inlinable public func makeModule(name: String = "") -> LLVMModule {
        LLVMModule(context: self, name: name)
    }
}
