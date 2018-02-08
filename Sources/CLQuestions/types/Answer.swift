public enum Answer {
    case stringAnswer(String)
    case boolAnswer(Bool)
    case stringArrayAnswer([String])

    public func text() -> String? {
        switch self {
        case .stringAnswer(let value):
            return value
        default:
            return nil
        }
    }

    public func bool() -> Bool? {
        switch self {
        case .boolAnswer(let value):
            return value
        default:
            return nil
        }
    }
}
