//
//  Date+Extension.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/8/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation

extension Date {
  // get an ISO timestamp
  static func getISOTimestamp() -> String {
    let isoDateFormatter = ISO8601DateFormatter()
    let timestamp = isoDateFormatter.string(from: Date())
    return timestamp
  }
}
