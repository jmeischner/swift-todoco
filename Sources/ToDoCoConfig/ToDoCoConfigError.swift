import Foundation

public enum ToDoCoConfigError: Error {
  case directoryIsNoToDoCoProject
  case configFileAlreadyExist
  case configFileIsNotValid
  case ignoreFileCouldNotBeRead
  case ignoreFileCanNotBeWritten
  case invalidToDoCoIgnore
}
