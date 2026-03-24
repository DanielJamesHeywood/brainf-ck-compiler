import LLVM

public enum LLVMOptimizationLevel {
    case none
    case less
    case `default`
    case aggressive
}

extension LLVMOptimizationLevel {
    
    @inlinable var rawOptimizationLevel: LLVMCodeGenOptLevel {
        switch self {
        case .none:
            return LLVMCodeGenLevelNone
        case .less:
            return LLVMCodeGenLevelLess
        case .default:
            return LLVMCodeGenLevelDefault
        case .aggressive:
            return LLVMCodeGenLevelAggressive
        }
    }
}
