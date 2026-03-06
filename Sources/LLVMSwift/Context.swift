import LLVM

public class Context {
    
    @usableFromInline let context = LLVMContextCreate() as LLVMContextRef
    
    @inlinable deinit {
        LLVMContextDispose(context)
    }
}

extension Context {
    
    @inlinable public func makeBuilder() -> Builder {
        Builder(context: self)
    }
    
    @inlinable public func makeModule(name: String) -> Module {
        Module(name: name, context: self)
    }
}
