import LLVM

public enum LLVMPredicate {
    case equalTo
    case notEqualTo
    case unsignedGreaterThan
    case unsignedGreaterThanOrEqualTo
    case unsignedLessThan
    case unsignedLessThanOrEqualTo
    case signedGreaterThan
    case signedGreaterThanOrEqualTo
    case signedLessThan
    case signedLessThanOrEqualTo
}

extension LLVMPredicate {
    
    @inlinable func toIntPredicate() -> LLVMIntPredicate {
        switch self {
        case .equalTo:
            return LLVMIntEQ
        case .notEqualTo:
            return LLVMIntNE
        case .unsignedGreaterThan:
            return LLVMIntUGT
        case .unsignedGreaterThanOrEqualTo:
            return LLVMIntUGE
        case .unsignedLessThan:
            return LLVMIntULT
        case .unsignedLessThanOrEqualTo:
            return LLVMIntULE
        case .signedGreaterThan:
            return LLVMIntSGT
        case .signedGreaterThanOrEqualTo:
            return LLVMIntSGE
        case .signedLessThan:
            return LLVMIntSLT
        case .signedLessThanOrEqualTo:
            return LLVMIntSLE
        }
    }
}
