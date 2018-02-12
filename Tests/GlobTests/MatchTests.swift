import Quick
import Nimble

@testable import Glob

class MatchPaths: QuickSpec {
    override func spec() {
        describe("Read a valid todococonfig file") {
            it("should result in a valid ToDoCoConfig instance") {
                var config: ToDoCoConfig

                do {
                    config = try ToDoCoConfigReader.readConfigFile(atPath: "Tests/ToDoCoConfigTests/fullConfig")
                    expect(config.project.name).to(equal("ToDoCo"))
                    expect(config.project.author).to(equal("Jan Meischner"))
                    expect(config.files.useGitignore).to(equal(true))
                    expect(config.files.toIgnore).to(equal(["node_modules/**/*", "src/extracting/regex.js"]))
                    expect(config.files.toAdd).to(equal([".todococonfig"]))
                } catch {}
            }
        }
    }
}
