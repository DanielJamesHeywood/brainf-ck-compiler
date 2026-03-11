import LLVM

public struct LLVMGEPNoWrapFlags: OptionSet, Sendable {
    
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension LLVMGEPNoWrapFlags {
    
    public static let inBounds = LLVMGEPNoWrapFlags(rawValue: LLVMGEPFlagInBounds)
    
    public static let noUnsignedSignedWrap = LLVMGEPNoWrapFlags(rawValue: LLVMGEPFlagNUSW)
    
    public static let noUnsignedWrap = LLVMGEPNoWrapFlags(rawValue: LLVMGEPFlagNUW)
}
