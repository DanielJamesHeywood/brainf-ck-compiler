import BFAbstractSyntaxTree
import Testing

@Suite struct AbstractSyntaxTreeTests {
    
    @Test func initializingAbstractSyntaxTreeWithUnmatchedStartLoop() {
        #expect(
            throws: AbstractSyntaxTree.InitializationError.unmatchedStartLoop,
            performing: {
                try AbstractSyntaxTree([.startLoop])
            }
        )
    }
    
    @Test func initializingAbstractSyntaxTreeWithUnmatchedEndLoop() {
        #expect(
            throws: AbstractSyntaxTree.InitializationError.unmatchedEndLoop,
            performing: {
                try AbstractSyntaxTree([.endLoop])
            }
        )
    }
}
