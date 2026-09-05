//
//  ALTTeam+AltStore.swift
//  AltStore
//
//  Created by Tim Kennedy on 9/5/26.
//  Copyright © 2026 Riley Testut. All rights reserved.
//

import Foundation
import AltSign

public extension ALTTeamType
{
    var localizedDescription: String {
        switch self
        {
        case .free: return NSLocalizedString("Free Developer Account", comment: "")
        case .individual: return NSLocalizedString("Developer", comment: "")
        case .organization: return NSLocalizedString("Organization", comment: "")
        case .unknown: fallthrough
        @unknown default: return NSLocalizedString("Unknown", comment: "")
        }
    }
}

public extension Collection where Element == ALTTeam
{
    // Paid teams are preferred over free teams because they have significantly higher limits
    // (e.g. 1-year provisioning profiles instead of 7 days, no 3-app limit, no 10 App ID limit).
    // Among paid teams, Individual is preferred over Organization because an Individual team
    // always belongs solely to the signed-in Apple ID.
    static var preferredTeamTypes: [ALTTeamType] {
        return [.individual, .organization, .free]
    }
    
    // The team AltStore/AltServer should use by default when an Apple ID belongs to multiple teams.
    var preferredTeam: ALTTeam? {
        for type in Self.preferredTeamTypes
        {
            if let team = self.first(where: { $0.type == type })
            {
                return team
            }
        }
        
        return self.first
    }
}
