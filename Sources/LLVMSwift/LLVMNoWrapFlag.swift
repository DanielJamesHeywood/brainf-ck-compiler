import LLVM

public enum LLVMNoWrapFlag {
    case inBounds
    case noUnsignedSignedWrap
    case noUnsignedWrap
}

extension LLVMNoWrapFlag {
    
    @inlinable var rawNoWrapFlag: LLVMGEPNoWrapFlags {
        switch self {
        case .inBounds:
            return LLVMGEPNoWrapFlags(LLVMGEPFlagInBounds)
        case .noUnsignedSignedWrap:
            return LLVMGEPNoWrapFlags(LLVMGEPFlagNUSW)
        case .noUnsignedWrap:
            return LLVMGEPNoWrapFlags(LLVMGEPFlagNUW)
        }
    }
}
