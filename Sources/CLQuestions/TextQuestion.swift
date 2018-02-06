extension Question {
    func askText() -> String? {
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
}
