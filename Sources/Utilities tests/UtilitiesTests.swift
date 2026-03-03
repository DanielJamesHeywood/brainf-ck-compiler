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
    
    @Suite struct PrintToFileTests {}
}
