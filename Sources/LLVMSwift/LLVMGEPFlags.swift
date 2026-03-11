import LLVM

public struct LLVMGEPFlags: OptionSet, Sendable {
    
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let inBounds = LLVMGEPFlags(rawValue: LLVMGEPFlagInBounds)
    
    public static let noUnsignedSignedWrap = LLVMGEPFlags(rawValue: LLVMGEPFlagNUSW)
    
    public static let noUnsignedWrap = LLVMGEPFlags(rawValue: LLVMGEPFlagNUW)
}
