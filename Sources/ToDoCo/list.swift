import Foundation
import Ignore
import ToDoCoConfig
import ToDoCoReader
import Rainbow

let dashes30 = String(repeating: "-", count: 30).yellow

func listFileWhichAreNotIgnored(atPath: String) {
    do {
        let ignore = ToDoCoIgnore(atRoot: atPath)
        let files = try ignore.files()
        let projectDirectory = URL(fileURLWithPath: atPath).lastPathComponent

        let directories = Dictionary(grouping: files, by: {
            URL(fileURLWithPath: $0)
                .pathComponents
                .drop { $0 != projectDirectory }
                .dropLast()
                .reduce("", { $0 + "/" +  $1 })
        }).sorted { $0.key < $1.key }

        print("\(dashes30) " + "Files".green + " \(dashes30)")
        for (dir, files) in directories {
            print("\u{25B8} \(dir):".cyan)
            for file in files {
                let filename = URL(fileURLWithPath: file).lastPathComponent
                print("  \(filename)")
            }
            print()
        }
        print(String(repeating: "-", count: 67).yellow)
    } catch ToDoCoConfigError.ignoreFileCouldNotBeRead {
        print("Error: It was not possible to read \(ToDoCoNames.ignoreFile).".red)
    } catch {
        print("An Error Occured: \(error)".red)
    }
}

func listToDos(atPath: String) {
    do {
        let ignore = ToDoCoIgnore(atRoot: atPath)
        let reader = ToDoCoReader(ignore: ignore)
        let todos = try reader.read()
        let todosByFiles = Dictionary(grouping: todos, by: { $0.file })

        print("\(dashes30) " + "Todos".green + " \(dashes30)")

        for (file, todos) in todosByFiles {
            print("\u{25B8} \(file)".cyan)
            for todo in todos {
                let linenumber = padLeft(String(todo.line), width: 4)
                print(" \(linenumber):".blue + " \(todo.text)")
            }
            print()   
        }
        print(padLeft("Found \(todos.count) Todos in \(todosByFiles.count) Files".green, width: 76))
        print(String(repeating: "-", count: 67).yellow)

    } catch ToDoCoConfigError.ignoreFileCouldNotBeRead {
        print("Error: It was not possible to read \(ToDoCoNames.ignoreFile).".red)
    } catch {
        print("An Error Occured: \(error)".red)
    }
}

private func getToDoCoConfig(atPath: String) throws -> ToDoCoConfig {
    var config: ToDoCoConfig = ToDoCoConfig()

    do {
      config = try ToDoCoConfigReader.readConfigFile(atPath: atPath)
    } catch ToDoCoConfigError.directoryIsNoToDoCoProject {
      print("Info: No \(ToDoCoNames.configFile) found at '\(atPath)', thus use default configuration.".yellow)
      print()
    }

    return config
}

private func padLeft(_ string: String, width: Int) -> String {
    if string.count > width {
        return string
    } else {
        let diff = width - string.count
        return String(repeating: " ", count: diff) + string
    }
}
