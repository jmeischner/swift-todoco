public class Questions {
    let questions: [String: Question]

    public init(questions: [String: Question]) {
        self.questions = questions
    }

    public func ask() throws -> [String: Answer] {
        var result = [String: Answer]()

        for (key, question) in questions {
            let answer = try question.ask()
            result[key] = answer
        }

        return result
    }
}
