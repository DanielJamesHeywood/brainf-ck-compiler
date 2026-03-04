import System
import Testing
import Utilities

@Suite struct UtilitiesTests {
    
    @Suite struct ExitTests {
        
        @Test func exitingWithSuccess() async {
            await #expect(
                processExitsWith: .success,
                performing: {
                    exit(with: .success)
                }
            )
        }
        
        @Test func exitingWithFailure() async {
            await #expect(
                processExitsWith: .failure,
                performing: {
                    exit(with: .failure)
                }
            )
        }
    }
    
    @Suite struct StringFromUTF8FileTests {}
    
    @Suite struct PrintToFileTests {
        
        @Test func printingToFile() throws {
            let (readEnd, writeEnd) = try FileDescriptor.pipe()
            try writeEnd.closeAfter {
                print("Hello, world!", to: writeEnd)
            }
            try readEnd.closeAfter {
                try #expect(String(utf8ContentsOf: readEnd, expectedByteCount: 14) == "Hello, world!\n")
            }
        }
        
        @Test func printingToFileWithDefaultSeparator() throws {
            let (readEnd, writeEnd) = try FileDescriptor.pipe()
            try writeEnd.closeAfter {
                print("Hello,", "world!", to: writeEnd)
            }
            try readEnd.closeAfter {
                try #expect(String(utf8ContentsOf: readEnd, expectedByteCount: 14) == "Hello, world!\n")
            }
        }
        
        @Test func printingToFileWithSeparator() throws {
            let (readEnd, writeEnd) = try FileDescriptor.pipe()
            try writeEnd.closeAfter {
                print("Hello,", " ", "world!", to: writeEnd, separator: "")
            }
            try readEnd.closeAfter {
                try #expect(String(utf8ContentsOf: readEnd, expectedByteCount: 14) == "Hello, world!\n")
            }
        }
        
        @Test func printingToFileWithTerminator() throws {
            let (readEnd, writeEnd) = try FileDescriptor.pipe()
            try writeEnd.closeAfter {
                print("Hello, world!\n", to: writeEnd, terminator: "")
            }
            try readEnd.closeAfter {
                try #expect(String(utf8ContentsOf: readEnd, expectedByteCount: 14) == "Hello, world!\n")
            }
        }
        
        @Test func printingToFileTwice() throws {
            let (readEnd, writeEnd) = try FileDescriptor.pipe()
            try writeEnd.closeAfter {
                print("Hello,", to: writeEnd, terminator: " ")
                print("world!", to: writeEnd)
            }
            try readEnd.closeAfter {
                try #expect(String(utf8ContentsOf: readEnd, expectedByteCount: 14) == "Hello, world!\n")
            }
        }
    }
}
