import Foundation
import Rainbow
import Yaml

/**
  # ToDoCoConfigReader

  A static class which is responsible for reading
  and parsing the config file of an ToDoco Project
*/
public final class ToDoCoConfigReader {

  /**
    # readConfigFile

    Is a public function of this class which
    results in a ToDoCoConfig instance.

    - Parameter at: Path to the Project directory
    - Returns: ToDoCoConfig instance
  */
  public class func readConfigFile(atPath path: String = ".") throws -> ToDoCoConfig {
    let filepath = path + "/" + ToDoCoNames.configFile.rawValue

    var fileContent = ""

    do {
      fileContent = try String(contentsOf: URL(fileURLWithPath: filepath))
    } catch {
      throw ToDoCoConfigError.ProjectDirectoryDoesNotExist
    } 

    // Todo: Test if the yaml itself is broken
    let config = try! Yaml.load(fileContent)
    
    return serialize(yaml:config)
  }

  /**
    # serialize

    Serializes a Yaml structure from a
    ToDoCo Config file to an instance of
    the ToDoCoConfig class.

    - Parameter yaml: The output from Yaml.load()
    - Returns: A ToDoCoConfig instance
  */
  class func serialize(yaml: Yaml) -> ToDoCoConfig {

    let name = yaml["project"]["name"].string
    let author = yaml["project"]["author"].string
    let useGitignore = yaml["files"]["useGitignore"].bool
    let toIgnore = unwrap(array: yaml["files"]["ignore"])  
    let toAdd = unwrap(array: yaml["files"]["add"])
    
    let project = ToDoCoProject(name: name, author: author)
    let files = ToDoCoFiles(useGitignore: useGitignore, toIgnore: toIgnore, toAdd: toAdd)

    return ToDoCoConfig(project: project, files: files)
  }

  class func unwrap(array: Yaml) -> [String]? {
    var result:[String]? = nil
    if let arrayUnwrapped = array.array {
      result = arrayUnwrapped.map{(ele) in 
        if let e = ele.string {
          return e 
        } else {
          return ""
        }
      }.filter {$0 != ""}
    }
    return result
  }

}