import Foundation

let toDoCoConfigDefaults: [String: Any]  = [
  "name": "Project Name" as String,
  "author": "Project Author" as String,
  "useGitignore": false as Bool,
  "toIgnore": [] as [String],
  "toAdd": ["**"] as [String]
]

public class ToDoCoConfig {
  public let project: ToDoCoProject
  public let files: ToDoCoFiles

  public init (project: ToDoCoProject = ToDoCoProject(), files: ToDoCoFiles = ToDoCoFiles()) {
    self.project = project
    self.files = files
  }

  public func toYaml() -> String {
    return """
    \(project.toYaml())
    \(files.toYaml())
    """
  }
}

public class ToDoCoProject {
  public let name: String
  public let author: String

  public init() {
    self.name = toDoCoConfigDefaults["name"] as! String
    self.author = toDoCoConfigDefaults["author"] as! String
  }

  public init(name: String?, author: String?) {
    if let n = name { self.name = n } else { self.name = toDoCoConfigDefaults["name"] as! String }
    if let a = author { self.author = a } else { self.author = toDoCoConfigDefaults["author"] as! String }
  }

  public func toYaml() -> String {
    return """
    project:
      name: \(name)
      author: \(author)
    """
  }
}

public class ToDoCoFiles {
  public let useGitignore: Bool
  public let toIgnore: [String]
  public let toAdd: [String]

  public init() {
    self.useGitignore = toDoCoConfigDefaults["useGitignore"] as! Bool
    self.toIgnore = toDoCoConfigDefaults["toIgnore"] as! Array<String>
    self.toAdd = toDoCoConfigDefaults["toAdd"] as! Array<String>
  }

  public init(useGitignore: Bool?) {
    if let ug = useGitignore {
      self.useGitignore = ug
    } else {
      self.useGitignore = toDoCoConfigDefaults["useGitignore"] as! Bool
    }

    self.toIgnore = toDoCoConfigDefaults["toIgnore"] as! Array<String>
    self.toAdd = toDoCoConfigDefaults["toAdd"] as! Array<String>
  }

  public init(useGitignore: Bool?, toIgnore: [String]?, toAdd: [String]?) {
    if let ug = useGitignore {
      self.useGitignore = ug
    } else {
      self.useGitignore = toDoCoConfigDefaults["useGitignore"] as! Bool
    }

    if let ti = toIgnore {
      self.toIgnore = ti
    } else {
      self.toIgnore = toDoCoConfigDefaults["toIgnore"] as! Array<String>
    }

    if let ta = toAdd {
      self.toAdd = ta
    } else {
      self.toAdd = toDoCoConfigDefaults["toAdd"] as! Array<String>
    }
  }

  public func toYaml() -> String {
    var result = """
    files:
      useGitignore: \(useGitignore)
      ignore:\n
    """
    for element in toIgnore {
      result += "    - \(element)\n"
    }
    result += "  add:\n"
    for element in toAdd {
      result += "    - \(element)\n"
    }

    return result
  }
}
