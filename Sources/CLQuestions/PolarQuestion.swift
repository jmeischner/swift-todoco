import Rainbow

extension Question {
    func askBool() throws -> Answer {

        var questionEnding = "(y/n)".yellow

        let defAns = defaultAnswer as? Bool
        var defaultA = false

        if let def = defAns {
            if def {
                questionEnding = "(Y/n)".yellow
                defaultA = true
            } else {
                questionEnding = "(y/N)".yellow
                defaultA = false
            }
        }

        print("\u{203A} ".cyan + text.bold + " " + questionEnding)

        if let answer = readLine() {
            if answer == "" {
                return Answer.boolAnswer(defaultA)
            } else {
                return try test(answer: answer)
            }
        } else {
            throw QuestionError.notPossibleToReadLine
        }
    }

    private func reask() throws -> Answer {
        // Todo: Internationalize
        print("Please enter a valid answer:".red)

        if let answer = readLine() {
            return try test(answer: answer)
        } else {
            throw QuestionError.notPossibleToReadLine
        }
    }

    private func test(answer: String) throws -> Answer {
        switch answer {
        case "y", "Y":
            return Answer.boolAnswer(true)
        case "n", "N":
            return Answer.boolAnswer(false)
        default:
            return try reask()
        }
    }
}
