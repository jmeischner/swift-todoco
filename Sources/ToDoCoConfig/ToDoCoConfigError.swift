import Foundation

public enum ToDoCoConfigError: Error {
  case directoryIsNoToDoCoProject
  case configFileAlreadyExist
}