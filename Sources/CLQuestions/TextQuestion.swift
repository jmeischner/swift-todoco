import Rainbow

extension Question {
    func askText() throws -> Answer {

        var questionText = "\u{203A} ".cyan + text.bold

        let defAns = defaultAnswer as? String

        if let def = defAns {
            questionText += " (\(def))".yellow
        }

        print(questionText)

        if let answer = readLine() {
            if answer.isEmpty {
                if let def = defaultAnswer as? String {
                    return Answer.stringAnswer(def)
                } else {
                    return Answer.stringAnswer(answer)
                }
            } else {
                return Answer.stringAnswer(answer)
            }
        } else {
            throw QuestionError.notPossibleToReadLine
        }
    }
}
