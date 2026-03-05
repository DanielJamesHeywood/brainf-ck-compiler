import BFAbstractSyntaxTree
import BFCommand
import System
import Utilities

do {
    guard CommandLine.arguments.count == 2 else {
        print("Expected exactly 1 argument, but got \(CommandLine.arguments.count - 1)", to: .standardError)
        exit(with: .failure)
    }
    let bfFilePath = FilePath(CommandLine.arguments[1])
    guard let bfFileExtension = bfFilePath.extension else {
        print("Expected a path to a brainf*ck file, but got a path to a file with no extension", to: .standardError)
        exit(with: .failure)
    }
    guard bfFileExtension == "bf" else {
        print("Expected a path to a brainf*ck file, but got a path to a file with extension '.\(bfFileExtension)'", to: .standardError)
        exit(with: .failure)
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
    exit(with: .failure)
}
