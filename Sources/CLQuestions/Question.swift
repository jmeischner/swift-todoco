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

        func reask() -> Bool {
            // Todo: Internationalize
            print("Please enter a valid answer:")

            if let answer = readLine() {
                return test(answer: answer)
            } else {
                return false
            }
        }

        func test(answer: String) -> Bool {
            switch answer {
            case "y", "Y":
                return true
            case "n", "N":
                return false
            default:
                return reask()
            }
        }

        var questionEnding = "(y/n)"

        let defAns = defaultAnswer as? Bool

        if let def = defAns {
            if def {
                questionEnding = "(Y/n)"
            } else {
                questionEnding = "(y/N)"
            }
        }

        print("\(text) \(questionEnding)")

        if let answer = readLine() {
            return test(answer: answer)
        } else {
            return false
        }
    }
}
