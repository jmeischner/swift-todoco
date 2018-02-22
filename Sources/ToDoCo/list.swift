import Foundation
import Ignore
import ToDoCoConfig
import ToDoCoReader

func listToDos(atPath: String) {
    do {
        let config = try getToDoCoConfig(atPath: atPath)
        let reader = ToDoCoReader(config: config)
        reader.read()
    } catch {
        print("An Error Occured: \(error)".red)
    }
}

private func getToDoCoConfig(atPath: String) throws -> ToDoCoConfig {
    var config: ToDoCoConfig = ToDoCoConfig()

    do {
      config = try ToDoCoConfigReader.readConfigFile(atPath: atPath)
    } catch ToDoCoConfigError.directoryIsNoToDoCoProject {
      print("Info: No \(ToDoCoNames.configFile.rawValue) found at '\(atPath)', thus use default configuration.".yellow)
      print()
    }

    return config
}
