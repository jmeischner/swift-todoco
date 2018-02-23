import Foundation
import Ignore

/**
Class for managing the ignore behavior of a
todoco project

    ```
    // Write the template
    ToDoCoIgnore.writeTemlate(atRoot: ".")

    // Get all files which are not ignored
    let ignore = ToDoCoIgnore(atRoot: ".")
    let files = try ignore.files()
    ```
*/
public class ToDoCoIgnore {

    static let template = """
        #!use .gitignore

        .git
        """

    let root: String

    /**
        Initializer of the ToDoCoIgnore class

        - Parameter atRoot: Path to the directory which
            contains the .todocoignore file (*Project Root*)
    */
    public init(atRoot: String) {
        root = atRoot
    }

    /**
        Writes default .todocoignore

        Class function to write the default .todocoignore
        to given root path

        - Parameter atRoot: Path to the root of the new todoco Project
    */
    public class func writeTemplate(atRoot: String) throws {

        var pathUrl = URL(fileURLWithPath: atRoot)
        pathUrl.appendPathComponent(ToDoCoNames.ignoreFile)

        do {
            try template.write(to: pathUrl, atomically: false, encoding: .utf8)
        } catch {
            throw ToDoCoConfigError.ignoreFileCanNotBeWritten
        }
    }

    /**
        Get Files from .todocoignore

        Function returns all files which are not ignored
        by the .todocoignore file or file this file uses

        - Returns: Array of file paths
        
        - Throws: `ToDoCoConfigError.ignoreFileCouldNotBeRead` if the ignore file
            can not be opened
        - Throws: `ToDoCoConfigError.invalidToDoCoIgnore` if the ignore file
            has an invalid format
        - Throws: `IgnoreError.noValidPattern` if the transformed pattern of an
            ignore file is not a valid NSRegularExpression pattern
    */
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
