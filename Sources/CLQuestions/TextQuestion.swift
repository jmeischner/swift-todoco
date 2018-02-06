extension Question {
    func askText() -> String? {

        var questionText = text

        let defAns = defaultAnswer as? String

        if let def = defAns {
            questionText += " (\(def))"
        }

        print(questionText)

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
}
