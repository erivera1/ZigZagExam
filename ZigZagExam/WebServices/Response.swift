
import Foundation
import ObjectMapper

class Response: Mappable {

  var success = false
  var errorMessage: String?

  required init?(map: Map) {
  }

  func mapping(map: Map) {
    success <- map["success"]
    if success {
      mappingOnSuccess(map: map)
    } else {
      errorMessage <- map["message"]
    }
  }

  func mappingOnSuccess(map: Map) {
    fatalError()
  }

}
