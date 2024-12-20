//
//  URLRequest+cURL.swift
//  URLRequest-cURL
//

import Foundation
public enum RequestDataType: String, Codable {
    case string
    case gzip_base64
    case unknown
}
extension URLRequest {
    
    public var cURL: String {
        return self.cURL(withHeaders: true, withBody: true)
    }
    
    public func cURL(withHeaders: Bool = true, withBody: Bool = true) -> String {
        var command = [String]()
        command.append(self.cURLBaseCommand())
        if withHeaders {
            if let curlHeaderString = self.cURLHeaders() {
                command.append(curlHeaderString)
            }
        }
        if withBody {
            if let curlBodyString = self.cURLBody() {
                command.append(curlBodyString)
            }
        }
        return command.joined(separator: " ")
    }
    
    public func cURLBaseCommand() -> String {
        guard let url = self.url else { return "" }
        var method = "GET"
        if let aMethod = self.httpMethod {
            method = aMethod
        }
        let baseCommand = "curl -X \(method) '\(url.absoluteString)'"
        return baseCommand
    }
    
    public func cURLHeaders() -> String? {
        var parameters = [String]()
        if let headers = self.allHTTPHeaderFields {
            let sortedKeys: [String] = headers.keys.sorted()
            for key in sortedKeys {
                if let value = headers[key] {
                    parameters.append("-H '\(key): \(value)'")
                }
            }
        }
        guard parameters.count > 0 else {
            return nil
        }
        return parameters.joined(separator: " ")
    }
    
    public func cURLBody() -> String? {
        guard var httpBodyString = self.getHttpBodyString() else {
            return nil
        }
        if let contentType = self.allHTTPHeaderFields?["Content-Type"],
            contentType == "application/json",
            let jsonObject = self.convertToJsonObject(text: httpBodyString.body ?? ""),
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: self.jsonWriteOptions()),
            let jsonString = String(data: jsonData, encoding: .utf8) {
            
            httpBodyString.body = jsonString
        }
        return "-d '\(httpBodyString.body ?? "")'"
    }
    
    fileprivate func jsonWriteOptions() -> JSONSerialization.WritingOptions {
        if #available(iOS 11.0, *) {
            return [.sortedKeys, .prettyPrinted]
        }
        return .prettyPrinted
    }
    
    func getHttpBodyString() -> TrackHTTPBody? {
        if let httpBodyString = self.getHttpBodyStream() {
            return (httpBodyString, .string)
        }
        if let httpBodyString = self.getHttpBody() {
            return httpBodyString
        }
        return nil
    }
    
    public func getHttpBodyStreamData() -> Data? {
        guard let httpBodyStream = self.httpBodyStream else {
            return nil
        }
        let data = NSMutableData()
        var buffer = [UInt8](repeating: 0, count: 4096)
        
        httpBodyStream.open()
        while httpBodyStream.hasBytesAvailable {
            let length = httpBodyStream.read(&buffer, maxLength: 4096)
            if length == 0 {
                break
            } else {
                data.append(&buffer, length: length)
            }
        }
        return data as Data
    }
    
    public func getHttpBodyStream() -> String? {
        guard let data = self.getHttpBodyStreamData() else {
            return nil
        }
        return NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) as String?
    }
    
    
    typealias TrackHTTPBody = (body: String? , dataType: RequestDataType)
    
    func getHttpBody() -> TrackHTTPBody? {
        guard let httpBody = self.httpBody, httpBody.count > 0 else {
            return nil
        }
        guard let httpBodyString = self.getStringFromHttpBody(httpBody: httpBody), let body = httpBodyString.body else {
            return nil
        }
        let escapedHttpBody = self.escapeAllSingleQuotes(body)
        return (escapedHttpBody, httpBodyString.dataType)
    }
    
    fileprivate func getStringFromHttpBody(httpBody: Data) -> TrackHTTPBody? {
        if httpBody.isGzipped {
            do {
                //Gzip string
                let gziped = try httpBody.gunzipped()
                let gzipedString = String(data: gziped, encoding: .utf8)
                if gzipedString != nil {
//                    print("gzipedString", url?.absoluteString)
                }
                
                if gzipedString?.isEmpty ?? true || gzipedString == nil {
                    //Base 64 string
                    let base64 = httpBody.base64EncodedString()
                    if !base64.isEmpty {
                        return (base64, .gzip_base64)
                    }
                } else {
                    return (gzipedString, .string)
                }
            } catch (_) {
                if let httpBodyString = String(data: httpBody, encoding: String.Encoding.utf8) {
                    return (httpBodyString, .string)
                } else {
                    return ("", .unknown)
                }
            }
        }
        
        if let httpBodyString = String(data: httpBody, encoding: String.Encoding.utf8) {
            return (httpBodyString, .string)
        }
        
        return ("", .unknown)
    }
    
    fileprivate func escapeAllSingleQuotes(_ value: String) -> String {
        return value.replacingOccurrences(of: "'", with: "'\\''")
    }
    
    fileprivate func convertToJsonObject(text: String) -> Parameter? {
        if let data = text.data(using: .utf8) {
            return try! JSONSerialization.jsonObject(with: data, options: []) as? Parameter
        }
        return nil
    }
}
