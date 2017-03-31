//
//  Helpers.swift
//  Flicks
//
//  Created by yanze on 3/30/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkConnectionDelegate: NSObjectProtocol {
    func connectionBannerAnimateIn()
    func connectionBannerAnimateOut()
}

class Helper: NSObject {
    static let sharedInstance = Helper()
    var delegate: NetworkConnectionDelegate?
    var hasConnection = Bool()
    var reachability = Reachability()!
    
    func startListeningConnectionChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: ReachabilityChangedNotification, object: reachability)
        do {
            try reachability.startNotifier()
        }catch {
            print("cannot start reachability notifier")
        }
    }
    
    func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
                hasConnection = true
                if delegate != nil {
                    delegate?.connectionBannerAnimateOut()
                }
            } else {
                print("Reachable via Cellular")
                hasConnection = true
                if delegate != nil {
                    delegate?.connectionBannerAnimateOut()
                }
            }
        } else {
            print("Network not reachable")
            hasConnection = false
            if delegate != nil {
                delegate?.connectionBannerAnimateIn()
            }
        }
    }
    
    
}
