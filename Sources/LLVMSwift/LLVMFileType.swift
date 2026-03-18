import LLVM

public enum LLVMFileType {
    case assembly
    case object
}

extension LLVMFileType {
    
    @inlinable var rawFileType: LLVMCodeGenFileType {
        switch self {
        case .assembly:
            return LLVMAssemblyFile
        case .object:
            return LLVMObjectFile
        }
    }
}
