//
//  Petition.swift
//  Whitehouse Petitions
//
//  Created by mac_os on 23/08/1440 AH.
//  Copyright © 1440 mac_os. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
