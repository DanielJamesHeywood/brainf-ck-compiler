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
    
    @Suite struct InitializeStringFromUTF8FileTests {
        
        @Test func initializingStringFromUTF8() throws {
            let (readEnd, writeEnd) = try FileDescriptor.pipe()
            try writeEnd.closeAfter {
                try writeEnd.writeAll("Hello, world!".utf8)
            } as Void
            try readEnd.closeAfter {
                try #expect(String(utf8ContentsOf: readEnd, expectedByteCount: 14) == "Hello, world!")
            }
        }
        
        @Test func initializingStringFromInvalidUTF8() throws {
            let (readEnd, writeEnd) = try FileDescriptor.pipe()
            try writeEnd.closeAfter {
                try writeEnd.writeAll([128])
            } as Void
            try readEnd.closeAfter {
                #expect(
                    throws: UTF8.ValidationError(.unexpectedContinuationByte, at: 0),
                    performing: {
                        try String(utf8ContentsOf: readEnd, expectedByteCount: 1)
                    }
                )
            } as Void
        }
    }
    
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
