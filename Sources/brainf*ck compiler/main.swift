import BFAbstractSyntaxTree
import BFCommand
import BFLLVM
import LLVMSwift
import System
import Utilities

do {
    guard CommandLine.arguments.count >= 2 else {
        print("Expected at least 1 argument, but got 0", to: .standardError)
        exit(with: .failure)
    }
    let bfFilePath = FilePath(CommandLine.arguments[1])
    guard let bfFileExtension = bfFilePath.extension, let bfFileStem = bfFilePath.stem else {
        print("Expected a path to a brainf*ck file, but got a path to a file with no extension", to: .standardError)
        exit(with: .failure)
    }
    guard bfFileExtension == "bf" else {
        print("Expected a path to a brainf*ck file, but got a path to a file with extension '.\(bfFileExtension)'", to: .standardError)
        exit(with: .failure)
    }
    var emitLLVMIR = false
    var emitAssembly = false
    for argument in CommandLine.arguments.dropFirst(2) {
        switch argument {
        case "-emit-llvm-ir":
            emitLLVMIR = true
        case "-emit-assembly":
            emitAssembly = true
        default:
            print("Unexpected argument: '\(argument)'", to: .standardError)
            exit(with: .failure)
        }
    }
    let contentsOfBFFile: String
    do {
        contentsOfBFFile = try String(utf8ContentsOfFileAt: bfFilePath)
    } catch {
        print("Failed to read from '\(bfFilePath)': \(error)", to: .standardError)
        exit(with: .failure)
    }
    let commands = contentsOfBFFile.compactMap { character in Command(character) }
    let abstractSyntaxTree: AbstractSyntaxTree
    do {
        abstractSyntaxTree = try AbstractSyntaxTree(commands)
    } catch .unmatchedStartLoop {
        print("'\(bfFilePath)' contains an unmatched opening bracket ('[')", to: .standardError)
        exit(with: .failure)
    } catch .unmatchedEndLoop {
        print("'\(bfFilePath)' contains an unmatched closing bracket (']')", to: .standardError)
        exit(with: .failure)
    }
    initializeAllTargetInfos()
    initializeAllTargets()
    initializeAllTargetMCs()
    initializeAllAsmPrinters()
    let context = LLVMContext()
    let triple = makeDefaultTargetTriple()
    let target: LLVMTarget
    do {
        target = try LLVMTarget(triple: triple)
    } catch {
        print("Failed to create an LLVM target from '\(triple)': \(error)", to: .standardError)
        exit(with: .failure)
    }
    let targetMachineOptions = LLVMTargetMachineOptions(cpu: makeHostCPUName(), features: makeHostCPUFeatures())
    let targetMachine = LLVMTargetMachine(target: target, triple: triple, options: targetMachineOptions)
    let module = context.makeModule(
        from: abstractSyntaxTree,
        sourceFilePath: bfFilePath,
        dataLayout: targetMachine.makeDataLayout(),
        triple: triple,
        id: bfFileStem
    )
    var exitCode = ExitCode.success
    do {
        var filePath = FilePath(bfFileStem)
        filePath.extension = "o"
        try targetMachine.emit(module, as: .object, toFileAt: filePath)
    } catch {
        print("Failed to create the object file: \(error)", to: .standardError)
        exitCode = .failure
    }
    if emitLLVMIR {
        do {
            var filePath = FilePath(bfFileStem)
            filePath.extension = "ll"
            try module.print(toFileAt: filePath)
        } catch {
            print("Failed to create the LLVM IR file: \(error)", to: .standardError)
            exitCode = .failure
        }
    }
    if emitAssembly {
        do {
            var filePath = FilePath(bfFileStem)
            filePath.extension = "s"
            try targetMachine.emit(module, as: .assembly, toFileAt: filePath)
        } catch {
            print("Failed to create the assembly file: \(error)", to: .standardError)
            exitCode = .failure
        }
    }
    exit(with: exitCode)
}
