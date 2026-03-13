
public enum Command {
    case incrementPointer
    case decrementPointer
    case incrementByte
    case decrementByte
    case outputByte
    case inputByte
    case startLoop
    case endLoop
}

extension Command {
    
    @inlinable public init?(_ character: Character) {
        switch character {
        case ">":
            self = .incrementPointer
        case "<":
            self = .decrementPointer
        case "+":
            self = .incrementByte
        case "-":
            self = .decrementByte
        case ".":
            self = .outputByte
        case ",":
            self = .inputByte
        case "[":
            self = .startLoop
        case "]":
            self = .endLoop
        default:
            return nil
        }
    }
}
