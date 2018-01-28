import Foundation

public enum ToDoCoConfigError: Error {
  case ProjectDirectoryDoesNotExist
  case ConfigFileAlreadyExist
}