//
//  WebAPI.swift
//  broadkazz
//
//  Created by Eliric Rivera on 14/08/2017.
//  Copyright © 2017 Eliric Rivera. All rights reserved.


import Foundation
import Alamofire
class WebApi {
  
  var queue: DispatchQueue { return DispatchQueue.global() }
  
  
  class var baseUrl: String { return "https://api.foursquare.com/v2/" }
  
  static func handleJson<T>(response: DataResponse<Any>, fieldName: String, onSuccess: @escaping (T)->Void, onError: @escaping (Error)->Void) {
    if let error = response.error ?? response.result.error {
      onError(error)
      return
    }
    guard let result = response.result.value as? [String : Any], let success = result["success"] as? Bool else {
      onError(WebApiError.unrecognizedResponse)
      return
    }
    guard success else {
      let message = result["message"] as? String ?? "Request failed with unkown reason."
      onError(WebApiError.requestFailed(message))
      return
    }
    guard let value = result[fieldName] as? T else {
      onError(WebApiError.incompleteResponse)
      return
    }
    onSuccess(value)
  }
    
  static func handleObject<T: Response>(response: DataResponse<T>, onSuccess: @escaping (T)->Void, onError: @escaping (Error)->Void) {
    if let error =  response.error ?? response.result.error {
      onError(error)
      return
    }
    guard let result = response.result.value else {
      onError(WebApiError.unrecognizedResponse)
      return
    }
    guard result.success else {
      onError(WebApiError.requestFailed(result.errorMessage ?? "Request failed with unkown reason."))
      return
    }
    onSuccess(result)
  }
  
  static func handlePostResponse(_ response: DataResponse<Any>, onSuccess: @escaping ()->Void, onError: @escaping (Error)->Void) {
    WebApi.handleJson(
      response: response,
      fieldName: "success",
      onSuccess: {
        (_: Bool) in
        onSuccess()
    },
      onError: onError)
  }
  
  
  func buildUrl(paths: [String]) -> String {
    var url = WebApi.baseUrl
    for path in paths {
      url += "/\(path)"
    }
    return url
  }
}
