
import Foundation

enum WebApiError: Error, LocalizedError {

  case unrecognizedResponse
  case requestFailed(String)
  case incompleteResponse
  case invalidRequest

  var errorDescription: String? {
    switch self {
    case .unrecognizedResponse:
      return "Unrecognized response."
    case .requestFailed(let message):
      return message
    case .incompleteResponse:
      return "Incomplete response."
    case .invalidRequest:
      return "Invalid request."
    }
  }

}
