import Foundation
import Ignore

public class ToDoCoIgnore {

    static let template = """
        #!use .gitignore

        .git
        """

    let root: String

    public init(atRoot: String) {
        root = atRoot
    }

    public class func writeTemplate(atRoot: String) throws {

        var pathUrl = URL(fileURLWithPath: atRoot)
        pathUrl.appendPathComponent(ToDoCoNames.ignoreFile)

        do {
            try template.write(to: pathUrl, atomically: false, encoding: .utf8)
        } catch {
            throw ToDoCoConfigError.ignoreFileCanNotBeWritten
        }
    }

    public func files() throws -> [String] {
        let patterns = try parse()
        return try pathsFrom(root: root, ignorePattern: patterns)
    }

    private func parse() throws -> [String] {

        var result = [String]()

        let lines = try getIgnoreLines(ofFile: ToDoCoNames.ignoreFile, defaultContent: ToDoCoIgnore.template)

        let patterns = lines.filter { !$0.hasPrefix("#")}
        let uses = try lines
            .filter { $0.hasPrefix("#!use ")}
            .map(extractUse)

        for use in uses {
            result += try getIgnoreLines(ofFile: use)
        }

        result += patterns

        return result
    }

    private func getIgnoreLines(ofFile: String, defaultContent: String = "") throws -> [String] {
        var fileContent = defaultContent

        var pathUrl = URL(fileURLWithPath: root)
        pathUrl.appendPathComponent(ofFile)

        let path = pathUrl.path

        if FileManager.default.fileExists(atPath: path) {
            guard let fileContentOpt = try? String(contentsOfFile: path) else {
                throw ToDoCoConfigError.ignoreFileCouldNotBeRead
            }

            fileContent = fileContentOpt
        }

        return fileContent.split(separator: "\n").map { String($0) }
    }

    private func extractUse(line: String) throws -> String {

        guard let whiteSpaceIndex = line.index(of: " ") else {
            throw ToDoCoConfigError.invalidToDoCoIgnore
        }

        let fileIndex = line.index(after: whiteSpaceIndex)

        return String(line.suffix(from: fileIndex))
    }
}
