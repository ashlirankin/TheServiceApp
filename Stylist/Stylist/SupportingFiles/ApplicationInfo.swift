//
//  ApplicationInfo.swift
//  Stylist
//
//  Created by Ashli Rankin on 5/6/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation

class ApplicationInfo {
  class func getVersionBuildNumber() -> String {
    guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString"),
      let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")
      else {
        fatalError("no version info")
    }
    return "\(version) (\(build))"
  }
  
  class func getAppName() -> String {
    guard let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String else {
      fatalError("what? no app name")
    }
    return appName
  }
}




