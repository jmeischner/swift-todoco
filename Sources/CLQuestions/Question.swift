// Todo: Add argument for validation closure

public class Question {
    let text: String
    let type: QuestionType
    let defaultAnswer: Any?
    let choices: [String]

    public init(
        text: String,
        type: QuestionType = .text,
        defaultAnswer: Any? = nil,
        choices: [String] = []
    ) {
        self.text = text
        self.type = type
        self.choices = choices
        self.defaultAnswer = defaultAnswer
    }

    public func ask() throws -> Answer {

        switch type {
        case .text:
            return try askText()
        case .bool:
            return try askBool()
        default:
            return try askText()
        }
    }
}
