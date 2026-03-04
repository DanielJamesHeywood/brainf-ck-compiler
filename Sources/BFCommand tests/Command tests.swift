import BFCommand
import Testing

@Suite struct CommandTests {
    
    @Test func initializingCommandToIncrementPointer() {
        #expect(Command(">") == .incrementPointer)
    }
    
    @Test func initializingCommandToDecrementPointer() {
        #expect(Command("<") == .decrementPointer)
    }
    
    @Test func initializingCommandToIncrementByte() {
        #expect(Command("+") == .incrementByte)
    }
    
    @Test func initializingCommandToDecrementByte() {
        #expect(Command("-") == .decrementByte)
    }
    
    @Test func initializingCommandToOutputByte() {
        #expect(Command(".") == .outputByte)
    }
    
    @Test func initializingCommandToInputByte() {
        #expect(Command(",") == .inputByte)
    }
    
    @Test func initializingCommandToStartLoop() {
        #expect(Command("[") == .startLoop)
    }
    
    @Test func initializingCommandToEndLoop() {
        #expect(Command("]") == .endLoop)
    }
    
    @Test func initializingCommandsFromInvalidCharacters() {
        #expect("Hello, world!".compactMap { character in Command(character) } == [.inputByte])
    }
}
