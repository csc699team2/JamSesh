//
//  Message.swift
//  JamSesh
//
//  Created by Kurtis Hoang on 4/28/19.
//  Copyright © 2019 Monali Chuatico. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

struct Message {
    let member: Member
    let text: String
    let messageId: String
}

extension Message: MessageType {
    
    var sender: Sender {
        return Sender(id: member.name, displayName: member.name)
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}

struct Member {
    let name: String
}

extension Member {
    var toJSON: Any {
        return [
            "name": name
        ]
    }
    
    init?(fromJSON json: Any) {
        guard
            let data = json as? [String: Any],
            let name = data["name"] as? String
            else {
                print("Couldn't parse Member")
                return nil
        }
        
        self.name = name
    }
}
