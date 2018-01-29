import Quick
import Nimble
import Yaml

@testable import ToDoCoConfig

class WriteConfigFile: QuickSpec {
    override func spec() {
        describe("ToDoCoProject toYaml") {
            it("should result in a valid yaml string") {
                let project = ToDoCoProject()
                let yamlString = project.toYaml()
                var yaml: Yaml = Yaml.string("")

                do {
                    yaml = try Yaml.load(yamlString)
                } catch {}

                expect(yaml["project"]["name"].string).to(equal("Project Name"))
                expect(yaml["project"]["author"].string).to(equal("Project Author"))
            }
        };

        describe("ToDoCoFiles toYaml") {
            it("should result in a valid yaml string") {
                let files = ToDoCoFiles()
                let yamlString = files.toYaml()
                var yaml: Yaml = Yaml.string("")

                do {
                    yaml = try Yaml.load(yamlString)
                } catch {}

                expect(yaml["files"]["useGitignore"].bool).to(beFalsy())
                expect(yaml["files"]["ignore"].array).to(beNil())
                expect(yaml["files"]["add"].array).to(equal(["**"]))
            }
        }
    }
}