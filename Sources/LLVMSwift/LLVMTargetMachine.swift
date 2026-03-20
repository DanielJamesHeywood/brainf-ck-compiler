import LLVM
import System

public class LLVMTargetMachine {
    
    @usableFromInline let rawTargetMachine: LLVMTargetMachineRef
    
    @inlinable public init(target: LLVMTarget, triple: LLVMTriple, options: LLVMTargetMachineOptions) {
        self.rawTargetMachine = LLVMCreateTargetMachineWithOptions(target.rawTarget, triple.rawMessage, options.rawOptions)
    }
    
    @inlinable deinit {
        LLVMDisposeTargetMachine(rawTargetMachine)
    }
}

extension LLVMTargetMachine {
    
    @inlinable public func makeDataLayout() -> LLVMTargetData {
        LLVMTargetData(rawTargetData: LLVMCreateTargetDataLayout(rawTargetMachine))
    }
}

extension LLVMTargetMachine {
    
    @inlinable public func emit(_ module: LLVMModule, as fileType: LLVMFileType, toFileAt path: FilePath) throws(LLVMError) {
        var rawErrorMessage: UnsafeMutablePointer<CChar>?
        guard LLVMTargetMachineEmitToFile(
            rawTargetMachine,
            module.rawModule,
            path.string,
            fileType.rawFileType,
            &rawErrorMessage
        ) == 0 else {
            throw LLVMError(LLVMMessage(rawMessage: rawErrorMessage.unsafelyUnwrapped))
        }
    }
}
