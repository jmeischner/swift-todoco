import Quick
import Nimble

@testable import ToDoCoConfig

class ReadConfigFile: QuickSpec {
    override func spec() {
        describe("Read a valid todococonfig file") {
            it("should result in a valid ToDoCoConfig instance") {
                let config = try! ToDoCoConfigReader.readConfigFile(atPath: "Tests/ToDoCoConfigTests/fullConfig")

                expect(config.project.name).to(equal("ToDoCo"))
                expect(config.project.author).to(equal("Jan Meischner"))
                expect(config.files.useGitignore).to(equal(true))
                expect(config.files.toIgnore).to(equal(["node_modules/**/*", "src/extracting/regex.js"]))
                expect(config.files.toAdd).to(equal([".todococonfig"]))
            }
        };

        describe("Read a todoconfig file") {

            context("with missing fields") {
                it("should fill project name with empty string") {
                    let config = try! ToDoCoConfigReader.readConfigFile(atPath: "Tests/ToDoCoConfigTests/missingProjectName")

                    expect(config.project.name).to(equal(""))
                    expect(config.project.author).to(equal("Jan Meischner"))
                }

                it("should fill project with empty ToDoCoProject") {
                    let config = try! ToDoCoConfigReader.readConfigFile(atPath: "Tests/ToDoCoConfigTests/missingProject")

                    expect(config.project.name).to(equal(""))
                    expect(config.project.author).to(equal(""))
                }

                it("should fill files with empty ToDoCoFiles") {
                    let config = try! ToDoCoConfigReader.readConfigFile(atPath: "Tests/ToDoCoConfigTests/missingFiles")

                    expect(config.project.name).to(equal("ToDoCo"))
                    expect(config.project.author).to(equal("Jan Meischner"))
                    expect(config.files.useGitignore).to(beFalsy())
                    expect(config.files.toIgnore).to(equal([""]))
                    expect(config.files.toAdd).to(equal(["**"]))
                }
            }
        };

        // Todo: Try Catch when file existiert nicht
        describe("Return a default ToDoCoConfig") {
            it("if no file is there") {
                let config = try! ToDoCoConfigReader.readConfigFile(atPath: "Test/ToDoCoConfigTests/noConfigFile")

                expect(config.project.name).to(equal(""))
                expect(config.project.author).to(equal(""))
                expect(config.files.useGitignore).to(beFalsy())
                expect(config.files.toIgnore).to(equal([""]))
                expect(config.files.toAdd).to(equal(["**"]))
            }
        }
        
    }
}