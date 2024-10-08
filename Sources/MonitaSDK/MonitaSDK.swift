// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import UIKit

extension UserDefaults {
    enum Keys: String {
        case requestListCall = "RequestListCall"
        case requestList = "RequestList"
        
    }
    func setVal(value: Any, key: Keys) {
        setValue(value, forKey: key.rawValue)
    }
    func getVal(key: Keys) -> Any? {
        return value(forKey: key.rawValue)
    }
}

public class MonitaSDK: NSObject {
    static let shared = MonitaSDK()
    let task = URLSession.shared
    private var serverURL: URL?
                                        //https://storage.googleapis.com/cdn-monita-dev/custom-config/$token.json?v=$unixTime
    private var configURL: URL {
        let unixTime = "\(Int(Date().timeIntervalSince1970))"
        return URL(string: "https://storage.googleapis.com/cdn-monita-dev/custom-config/\(token).json?v=\(unixTime)")!
    }
    private let fetchInterval: TimeInterval = 5 * 24 * 60 * 60 // 5 days in seconds
    private let lastFetchDateKey = "LastFetchDate"
    var token: String = ""
    // Call this method in AppDelegate's didFinishLaunchingWithOptions
    public static func configure() {
        if let token = Bundle.main.infoDictionary?["MonitaSDKToken"] as? String {
            MonitaSDK.shared.token = token
        } else {
            UIApplication.showAlert(message: "Token not available in plist file")
        }

        
        // Register the URL Protocol
       UserDefaults.standard.setVal(value: [], key: .requestListCall)
       let queue = DispatchQueue(label: "com.example.myqueue", qos: .userInitiated)
       
       queue.async {
           URLProtocol.registerClass(RequestInterceptor.self)
           // Perform method swizzling for URLSession
                 URLSession.swizzleDataTask
//                 URLSession.swizzleDataTaskWithURL
       }
       
       MonitaSDK.shared.checkAndFetchConfiguration()
        
    }
    func delay(_ delay: Double, closure:@escaping () -> Void) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    // Check if it's time to fetch the configuration and do it if needed
    private func checkAndFetchConfiguration() {
        // Fetch the configuration from the server
        MonitaSDK.shared.fetchConfiguration()
        
    }
    
    // Fetch configuration from the server
    private func fetchConfiguration() {
//
//        return
        task.dataTask(with: configURL) {  data, response, error in
            print("api called")
            if let error = error {
                print("Failed to fetch configuration: \(error)")
                self.fetchConfigurationLocally()
                return
            }
            
            guard let data = data else {
                print("No data received")
                self.fetchConfigurationLocally()
                return
            }
            
            let config = RequestManager.shared.loadConfiguration(from: data)
            if config == nil {
                self.fetchConfigurationLocally()
            }
        }.resume()
        
        
    }
    
    func fetchConfigurationLocally() {
        print("Bundle.allBundles")
        print(Bundle.allBundles)
        print(Bundle.allFrameworks)
        
//        guard let bundle = Bundle(identifier: Constant.bundle),  let url = bundle.url(forResource: "AppGlobalConfigNew", withExtension: "json") else {
//                print("Failed to find AppGlobalConfig.json in bundle.")
//            
//                return
//            }

//            do {
                // Load the file data
                guard let data = jsonFIle.data(using: .utf8) else {
                    print("Failed to find AppGlobalConfig.json in bundle.")
                    return
                }
                print("Step 1")
                print("Configuration Detail")
                print(String(data: data, encoding: .utf8) ?? "")
                // Decode the JSON data
                _ = RequestManager.shared.loadConfiguration(from: data)
                
//            } catch {
//                print("Error decoding JSON: \(error)")
//                return
//            }
    }
    public static func getConfigList() -> String {
        var string = ""
        let vendors = RequestManager.shared.configuration?.vendors ?? []
        
        for vendor in vendors {
            string.append("Name: \(vendor.vendorName ?? "")\n")
            string.append("Patterns: \(vendor.urlPatternMatches ?? [])\n\n")
            string.append("---------------------------------------------\n\n")
        }
        return string
    }
    public static func getInterceptedRequestList() -> String {
        var string = ""
        
        let lists = UserDefaults.standard.getVal(key: .requestList) as? [[String: Any]] ?? []
        
        for list in lists where list["filtered"] as! Bool == true {
            string.append("\(list)\n")
            string.append("---------------------------------------------\n\n")
        }
        return string
    }
    public static func getInterceptedRequestListAll() -> String {
        var string = ""
        let lists = UserDefaults.standard.getVal(key: .requestList) as? [[String: Any]] ?? []
        
        for list in lists {
            string.append("\(list)\n")
            string.append("---------------------------------------------\n\n")
        }
        return string
    }
    let jsonFIle = """
{
  "monitoringVersion": "23",
  "vendors": [
    {
      "vendorName": "Google Analytics",
      "urlPatternMatches": [
        "https://www.google-analytics.com/g/collect",
        "firebase-settings.crashlytics",
        "fcm.googleapis.com",
        "firebase.com",
        "firebase.google.com",
        "firebase.googleapis.com",
        "firebaseapp.com",
        "firebaseappcheck.googleapis.com",
        "firebasedynamiclinks-ipv4.googleapis.com",
        "firebasedynamiclinks-ipv6.googleapis.com",
        "firebasedynamiclinks.googleapis.com",
        "firebaseinappmessaging.googleapis.com",
        "firebaseinstallations.googleapis.com",
        "firebaseio.com",
        "firebaselogging-pa.googleapis.com",
        "firebaselogging.googleapis.com",
        "firebaseperusertopics-pa.googleapis.com",
        "firebaseremoteconfig.googleapis.com"
      ],
      "eventParamter": "cv",
      "execludeParameters": [],
      "filters": []
    },
    {
      "vendorName": "Facebook (Meta Pixel)",
      "urlPatternMatches": [
        "facebook.com/tr/"
      ],
      "eventParamter": "ev",
      "execludeParameters": [],
      "filters": [
        {
          "key": "dl",
          "op": "eq",
          "val": [
            "stuff"
          ]
        }
      ]
    },
    {
      "vendorName": "Monita",
      "urlPatternMatches": [
        "https://us-central1-tag-monitoring-dev.cloudfunctions.net/monalytics"
      ],
      "eventParamter": "{{gtm}}-{{gdid}}-{{regex::(?<=https:\\/\\/)[\\w|-]*::url}}-1",
      "execludeParameters": [],
      "filters": [
        {
          "key": "type",
          "op": "blank"
        }
      ]
    }
  ],
  "allowManualMonitoring": true
}
"""
}

