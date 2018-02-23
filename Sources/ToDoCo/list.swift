import Foundation
import Ignore
import ToDoCoConfig
import ToDoCoReader
import Rainbow

func listToDos(atPath: String) {
    do {
        let config = try getToDoCoConfig(atPath: atPath)
        let reader = ToDoCoReader(config: config)
        let todos = try reader.read()
        
        let todosByFiles = Dictionary(grouping: todos, by: { $0.file })

        for (file, todos) in todosByFiles {
            print("In file \(file):".cyan)
            for todo in todos {
                // Todo: solve distance with padding between line: and text
                print("  \(todo.line):".blue + " \(todo.text)")
            }
            print()
        }

        print("Found \(todos.count) Todos in \(todosByFiles.count) Files".green)

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
