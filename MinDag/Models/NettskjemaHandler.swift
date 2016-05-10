//
//  NettskjemaHandler.swift
//  Mathys
//
//  Created by Paul Philip Mitchell on 16/12/15.
//  Copyright © 2015 Universitetet i Oslo. All rights reserved.
//

/*
import Foundation
import UIKit
import ResearchKit
import Alamofire

class NettskjemaHandler {
    private let pingUrl = "https://nettskjema.uio.no/ping.html"
    private let formUrl = "https://nettskjema.uio.no/answer/deliver.json?formId=69861"
    private let csrfField = "NETTSKJEMA_CSRF_PREVENTION"
    private let uploadField = "answersAsMap[492013].attachment.upload"
    
    private var csrfToken: String?
    
    
    private func getCsrfToken(completion: (String?, NSError?) -> Void) -> () {
        Alamofire.request(.GET, pingUrl)
            .validate()
            .responseString { response in
                switch response.result {
                case .Success(let data):
                    self.csrfToken = data
                    completion(data, nil)
                    NSLog("Request succeeded with data: \(data)")
                case .Failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    private func post(file: NSData, csrf: String) {
        Alamofire.upload(
            .POST,
            formUrl,
            multipartFormData: { multipartFormData in
                let tokenData = csrf.dataUsingEncoding(NSUTF8StringEncoding)
                multipartFormData.appendBodyPart(data: tokenData!, name: self.csrfField)
                multipartFormData.appendBodyPart(data: file, name: self.uploadField, fileName: "test1231123.csv", mimeType: "text/csv")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseString { response in
                        NSLog("Upload success: \(response.response)")
                    }
                case .Failure(let encodingError):
                    NSLog("Upload failed. Error: \(encodingError)")
                }
        })
    }
    
    func upload(file: NSData) {
        getCsrfToken { (data, error) in
            if let token = data {
                self.post(file, csrf: token)
            } else {
                NSLog("Failed to get CSRF token with error: \(error!)")
            }
        }
    }
}*/

/*class NettskjemaHandler {
    
    let request: NSURLRequest
    let backgroundWebView: UIWebView
    
    enum SCHEME_TYPE: String {
        case Mathys    = "https://nettskjema.uio.no/answer/norment.html"
        //case Answer     = "https://jboss-utv.uio.no/nettskjema/answer/answer.html"
    }
    
    init(scheme: SCHEME_TYPE) {
        self.request = NSURLRequest(URL: NSURL(string: scheme.rawValue)!)
        self.backgroundWebView = UIWebView()
        self.backgroundWebView.loadRequest(request)
    }
    
    func submit() {
        backgroundWebView.stringByEvaluatingJavaScriptFromString("document.getElementById('submit-answer').click();")
        print("did run submit")
    }
    
    func reload() {
        backgroundWebView.stopLoading()
    }
    
    func setExtraField(key: String, result: ORKResult) {
        // IMPORTANT NOTE: This is really not suitable for production use.
        //      - The code for ORKESerializer closely tracks the ResearchKit data model, which may change between versions.
        //      - There is no guarantee for backward or forward compatibility
        //      - ORKESerializer is only included in Apple's internal test app for new features for the ResearchKit API.
        
        /*print("Got result")
        let serializedResult = try? ORKESerializer.JSONDataForObject(result)
        print(NSString(data: serializedResult!, encoding: NSUTF8StringEncoding))*/
        //backgroundWebView.stringByEvaluatingJavaScriptFromString("Nettskjema.setExtraField('\(key)', \(serializedResult!));")
    }
    
}*/



