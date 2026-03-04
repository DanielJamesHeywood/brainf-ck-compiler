import System
import Testing
import Utilities

@Suite struct UtilitiesTests {
    
    @Suite struct ExitTests {
        
        @Test func exitingWithSuccessExitsWithSuccess() async {
            await #expect(
                processExitsWith: .success,
                performing: {
                    exit(with: .success)
                }
            )
        }
        
        @Test func exitingWithFailureExitsWithFailure() async {
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
        
        @Test func printingToFilePrintsToFile() throws {
            let (readEnd, writeEnd) = try FileDescriptor.pipe()
            try writeEnd.closeAfter {
                print("Hello, world!", to: writeEnd)
            }
            try readEnd.closeAfter {
                try #expect(String(utf8ContentsOf: readEnd, expectedByteCount: 14) == "Hello, world!\n")
            }
        }
    }
}
