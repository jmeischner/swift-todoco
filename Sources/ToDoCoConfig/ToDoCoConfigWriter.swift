import Foundation

/**
  # ToDoCoConfigWriter

  Static class for writing a ToDoCoConfig
  instance to file
 */
public class ToDoCoConfigWriter {

  public class func write(toPath path: String, config: ToDoCoConfig) throws {
    let configPathString = "\(path)/\(ToDoCoNames.configFile.rawValue)"
    let configPathUrl = URL(fileURLWithPath: configPathString)

    if FileManager.default.fileExists(atPath: configPathString) {
      throw ToDoCoConfigError.configFileAlreadyExist
    } else {
      let configYaml = config.toYaml()
      try configYaml.write(to: configPathUrl, atomically: false, encoding: .utf8)
    }
  }
}
