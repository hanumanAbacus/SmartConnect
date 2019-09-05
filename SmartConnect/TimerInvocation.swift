//
//  TimerInvocation.swift
//  SmartConnect
//
//  Created by Kheam Tan on 5/9/19.
//  Copyright © 2019 Abacus. All rights reserved.
//

import Foundation

final class TimerInvocation: NSObject {
    
    var callback: () -> ()
    
    init(callback: @escaping () -> ()) {
        self.callback = callback
    }
    
    @objc func invoke() {
        callback()
    }
}

extension Timer {
    
    static func scheduleTimer(timeInterval: TimeInterval, repeats: Bool, invocation: TimerInvocation) {
        
        Timer.scheduledTimer(
            timeInterval: timeInterval,
            target: invocation,
            selector: #selector(TimerInvocation.invoke),
            userInfo: nil,
            repeats: repeats)
    }
}
