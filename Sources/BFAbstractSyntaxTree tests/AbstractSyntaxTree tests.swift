import BFAbstractSyntaxTree
import Testing

@Suite struct AbstractSyntaxTreeTests {
    
    @Test func initializingAbstractSyntaxTreeFromIncrementPointer() throws {
        try #expect(AbstractSyntaxTree([.incrementPointer]).root == [.incrementPointer])
    }
    
    @Test func initializingAbstractSyntaxTreeFromDecrementPointer() throws {
        try #expect(AbstractSyntaxTree([.decrementPointer]).root == [.decrementPointer])
    }
    
    @Test func initializingAbstractSyntaxTreeFromIncrementByte() throws {
        try #expect(AbstractSyntaxTree([.incrementByte]).root == [.incrementByte])
    }
    
    @Test func initializingAbstractSyntaxTreeFromDecrementByte() throws {
        try #expect(AbstractSyntaxTree([.decrementByte]).root == [.decrementByte])
    }
    
    @Test func initializingAbstractSyntaxTreeFromOutputByte() throws {
        try #expect(AbstractSyntaxTree([.outputByte]).root == [.outputByte])
    }
    
    @Test func initializingAbstractSyntaxTreeFromInputByte() throws {
        try #expect(AbstractSyntaxTree([.inputByte]).root == [.inputByte])
    }
    
    @Test func initializingAbstractSyntaxTreeWithLoop() throws {
        try #expect(AbstractSyntaxTree([.startLoop, .endLoop]).root == [.loop([])])
    }
    
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
