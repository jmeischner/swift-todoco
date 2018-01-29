import Quick
import Nimble

@testable import ToDoCoConfig

class ReadConfigFile: QuickSpec {
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
        };

        describe("Read a todoconfig file") {

            context("with missing fields") {
                it("should fill project name with empty string") {

                    var config: ToDoCoConfig

                    do {
                        config = try ToDoCoConfigReader.readConfigFile(atPath: "Tests/ToDoCoConfigTests/missingProjectName")
                        expect(config.project.name).to(equal("Project Name"))
                        expect(config.project.author).to(equal("Jan Meischner"))
                    } catch {}
                }

                it("should fill project with empty ToDoCoProject") {

                    var config: ToDoCoConfig

                    do {
                        config = try ToDoCoConfigReader.readConfigFile(atPath: "Tests/ToDoCoConfigTests/missingProject")
                        expect(config.project.name).to(equal("Project Name"))
                        expect(config.project.author).to(equal("Project Author"))
                    } catch {}
                }

                it("should fill files with empty ToDoCoFiles") {

                    var config: ToDoCoConfig

                    do {
                        config = try ToDoCoConfigReader.readConfigFile(atPath: "Tests/ToDoCoConfigTests/missingFiles")
                        expect(config.project.name).to(equal("ToDoCo"))
                        expect(config.project.author).to(equal("Jan Meischner"))
                        expect(config.files.useGitignore).to(beFalsy())
                        expect(config.files.toIgnore).to(equal([]))
                        expect(config.files.toAdd).to(equal(["**"]))

                    } catch {}
                }
            }
        };

        // Todo: Try Catch when file existiert nicht
        describe("If no .todococonfig file exist") {
            it("it should throw an 'DirectoryIsNoToDoCoProject' error") {
                expect { try ToDoCoConfigReader.readConfigFile(atPath: "Tests/ToDoCoConfigTests/noConfig") }.to(throwError(ToDoCoConfigError.DirectoryIsNoToDoCoProject))
            }
        }
        
    }
}