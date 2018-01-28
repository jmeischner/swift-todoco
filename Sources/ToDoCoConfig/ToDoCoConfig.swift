import Foundation

let ToDoCoConfigDefaults: [String: Any]  = [
  "name": "",
  "author": "",
  "useGitignore": false,
  "toIgnore": [""],
  "toAdd": ["**"]
]

public class ToDoCoConfig {
  public let project: ToDoCoProject
  public let files: ToDoCoFiles

  public init (project: ToDoCoProject = ToDoCoProject(), files: ToDoCoFiles = ToDoCoFiles()) {
    self.project = project
    self.files = files
  }
}

public class ToDoCoProject {
  public let name: String
  public let author: String

  public init() {
    self.name = ToDoCoConfigDefaults["name"] as! String
    self.author = ToDoCoConfigDefaults["author"] as! String
  }

  public init(name: String?, author: String?) {
    if let n = name { self.name = n } else { self.name = ToDoCoConfigDefaults["name"] as! String }
    if let a = author { self.author = a } else { self.author = ToDoCoConfigDefaults["author"] as! String }
  }
}

public class ToDoCoFiles {
  public let useGitignore: Bool
  public let toIgnore: [String]
  public let toAdd: [String]

  public init() {
    self.useGitignore = ToDoCoConfigDefaults["useGitignore"] as! Bool
    self.toIgnore = ToDoCoConfigDefaults["toIgnore"] as! Array<String>
    self.toAdd = ToDoCoConfigDefaults["toAdd"] as! Array<String>
  }

  public init(useGitignore: Bool?, toIgnore: [String]?, toAdd: [String]?) {
    if let ug = useGitignore { self.useGitignore = ug } else { self.useGitignore = ToDoCoConfigDefaults["useGitignore"] as! Bool }
    if let ti = toIgnore { self.toIgnore = ti } else { self.toIgnore = ToDoCoConfigDefaults["toIgnore"] as! Array<String> }
    if let ta = toAdd { self.toAdd = ta } else { self.toAdd = ToDoCoConfigDefaults["toAdd"] as! Array<String> }
  }
}
