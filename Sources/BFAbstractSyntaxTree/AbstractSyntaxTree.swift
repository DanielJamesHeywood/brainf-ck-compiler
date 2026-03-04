import BFCommand

struct AbstractSyntaxTree {
    
    enum Node {
    case incrementPointer
    case decrementPointer
    case incrementByte
    case decrementByte
    case outputByte
    case inputByte
    case loop([Node])
    }
    
    enum InitializationError: Error {
    case unmatchedStartLoop
    case unmatchedEndLoop
    }
    
    let root: [Node]
    
    init(_ commands: some Sequence<Command>) throws(InitializationError) {
        var ancestors = [[]] as [[Node]]
        for command in commands {
            switch command {
            case .incrementPointer:
                ancestors[ancestors.endIndex - 1].append(.incrementPointer)
            case .decrementPointer:
                ancestors[ancestors.endIndex - 1].append(.decrementPointer)
            case .incrementByte:
                ancestors[ancestors.endIndex - 1].append(.incrementByte)
            case .decrementByte:
                ancestors[ancestors.endIndex - 1].append(.decrementByte)
            case .outputByte:
                ancestors[ancestors.endIndex - 1].append(.outputByte)
            case .inputByte:
                ancestors[ancestors.endIndex - 1].append(.inputByte)
            case .startLoop:
                ancestors.append([])
            case .endLoop:
                guard ancestors.count >= 2 else {
                    throw .unmatchedEndLoop
                }
                let children = ancestors.removeLast()
                ancestors[ancestors.endIndex - 1].append(.loop(children))
            }
        }
        guard ancestors.count == 1 else {
            throw .unmatchedStartLoop
        }
        self.root = ancestors[0]
    }
}
