extension Question {
    func askText() -> Answer? {

        var questionText = text

        let defAns = defaultAnswer as? String

        if let def = defAns {
            questionText += " (\(def))"
        }

        print(questionText)

        if let answer = readLine() {
            if answer.isEmpty {
                if let def = defaultAnswer as? String {
                    return Answer.stringAnswer(def)
                } else {
                    return nil
                }
            } else {
                return Answer.stringAnswer(answer)
            }
        } else {
            return nil
        }
    }
}
