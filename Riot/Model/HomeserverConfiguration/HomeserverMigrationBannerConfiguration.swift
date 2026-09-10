// 
// Copyright 2026 Element Creations Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
// Please see LICENSE files in the repository root for full details.
//

import Foundation

/// `HomeserverMigrationBannerConfiguration` gives the resolved configuration of the banner inviting users
/// to migrate to Element X, based on the `io.element.migration_banner` Well Known section and the default values.
@objcMembers
final class HomeserverMigrationBannerConfiguration: NSObject {
    /// Indicate if the banner is enabled for this homeserver.
    /// Note: this doesn't take into account a potential dismissal of the banner by the user.
    let isEnabled: Bool
    
    init(isEnabled: Bool) {
        self.isEnabled = isEnabled
        
        super.init()
    }
}
