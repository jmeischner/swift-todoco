extension Question {
    func askBool() -> Answer? {

        var questionEnding = "(y/n)"

        let defAns = defaultAnswer as? Bool
        var defaultA = false

        if let def = defAns {
            if def {
                questionEnding = "(Y/n)"
                defaultA = true
            } else {
                questionEnding = "(y/N)"
                defaultA = false
            }
        }

        print("\(text) \(questionEnding)")

        if let answer = readLine() {
            if answer == "" {
                return Answer.boolAnswer(defaultA)
            } else {
                return test(answer: answer)
            }
        } else {
            return nil
        }
    }

    private func reask() -> Answer? {
        // Todo: Internationalize
        print("Please enter a valid answer:")

        if let answer = readLine() {
            return test(answer: answer)
        } else {
            return nil
        }
    }

    private func test(answer: String) -> Answer? {
        switch answer {
        case "y", "Y":
            return Answer.boolAnswer(true)
        case "n", "N":
            return Answer.boolAnswer(false)
        default:
            return reask()
        }
    }
}
