import Foundation

public enum ToDoCoConfigError: Error {
  case DirectoryIsNoToDoCoProject
  case ConfigFileAlreadyExist
}