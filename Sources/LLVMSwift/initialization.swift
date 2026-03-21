import LLVM

@inlinable public func initializeAllTargetInfos() {
    LLVMInitializeAllTargetInfos()
}

@inlinable public func initializeAllTargets() {
    LLVMInitializeAllTargets()
}

@inlinable public func initializeAllTargetMCs() {
    LLVMInitializeAllTargetMCs()
}

@inlinable public func initializeAllAsmPrinters() {
    LLVMInitializeAllAsmPrinters()
}
