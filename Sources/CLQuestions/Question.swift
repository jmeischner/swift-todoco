import Foundation

public enum QuestionType {
    case text
    case select
    case multiselect
    case bool
}

public class Question<Type> {
    let text: String
    let type: QuestionType
    let defaultAnswer: Type?
    let choices: [String]

    public init(
        text: String,
        type: QuestionType = .text,
        defaultAnswer: Type? = nil,
        choices: [String] = []
    ) {
        self.text = text
        self.type = type
        self.choices = choices
        self.defaultAnswer = defaultAnswer
    }

    public func ask() -> Type? {

        switch type {
        case .text:
            return askText() as? Type
        case .bool:
            return askBool() as? Type
        default:
            return askText() as? Type
        }
    }

    private func askText() -> String? {
        print(text)

        if let answer = readLine() {
            if answer.isEmpty {
                return defaultAnswer as? String
            } else {
                return answer
            }
        } else {
            return defaultAnswer as? String
        }
    }

    private func askBool() -> Bool {
        return true
    }
}