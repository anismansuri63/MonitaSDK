//
//  NetworkRequestSniffableUrlProtocol.swift
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 26/8/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation

class NetworkRequestSniffableUrlProtocol: URLProtocol {
    
    open override class func canInit(with request: URLRequest) -> Bool {
        if request.url!.absoluteString.contains("dev-stream.getmonita") {
            return false
        }
        if NetworkInterceptor.shared.isRequestRedirectable(urlRequest: request) {
            return false
        }
        if let httpHeaders = request.allHTTPHeaderFields, httpHeaders.isEmpty {
            return false
        }
        if let httpHeaders = request.allHTTPHeaderFields, let refiredValue = httpHeaders["Refired"], refiredValue == "true" {
            return false
        }
        if let _ = URLProtocol.property(forKey: "NetworkRequestSniffableUrlProtocol", in: request) {
            return false
        }
        let url = request.url!
        print("\nStep 2")
        print("Intercepted URL")
        print(url.absoluteString)
        
        // Example: Send intercepted request details to a server
        let req = RequestManager.shared.shouldSendRequest(url: url)
        var requestDetails: [String : Any] = [
            "name": req.vender?.vendorName ?? "",
            "url": request.url!.absoluteString,
            "method": request.httpMethod ?? "GET",
            "headers": request.allHTTPHeaderFields ?? [:],
            "body": String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "",
            "filtered": req.filtered
        ]
        
        var list = UserDefaults.standard.getVal(key: .requestList) as? [[String: Any]] ?? []
        
        if req.filtered {
            print("\nStep 3")
            print("URL matches with Vendor pattern")
            
            let alternateRequest = URLRequestFactory().createURLRequest(originalUrlRequest: request)
            let cusBody = alternateRequest.getHttpBodyString()
            let val = cusBody?.body ?? ""
            requestDetails["body"] = val
            
            if !val.isEmpty {
                
            }
//            print("v", v)
            print(requestDetails)

            // Send to your server
            RequestManager.shared.sendToServer(requestDetail: requestDetails, vender: req.vender!)
        }
        list.append(requestDetails)
        UserDefaults.standard.setVal(value: list, key: .requestList)
        //NetworkInterceptor.shared.sniffRequest(urlRequest: request)
        return false
    }
    
    
    open override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        let mutableRequest: NSMutableURLRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.setProperty("YES", forKey: "NetworkRequestSniffableUrlProtocol", in: mutableRequest)
        return mutableRequest.copy() as! URLRequest
    }
}