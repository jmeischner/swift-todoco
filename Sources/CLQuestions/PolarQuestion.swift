extension Question {
    func askBool() -> Bool {

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

    private func reask() -> Bool {
        // Todo: Internationalize
        print("Please enter a valid answer:")

        if let answer = readLine() {
            return test(answer: answer)
        } else {
            return false
        }
    }

    private func test(answer: String) -> Bool {
        switch answer {
        case "y", "Y":
            return true
        case "n", "N":
            return false
        default:
            return reask()
        }
    }
}
