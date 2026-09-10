// 
// Copyright 2020-2024 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
// Please see LICENSE files in the repository root for full details.
//

import Foundation

// MARK: - Well Known

/// `VectorWellKnown` represents additional Well Known configuration specific to Element client
struct VectorWellKnown {
    let encryption: VectorWellKnownEncryptionConfiguration?
    let jitsi: VectorWellKnownJitsiConfiguration?
    let migrationBanner: VectorWellKnownMigrationBannerConfiguration?
    
    // Deprecated properties
    let deprecatedEncryption: VectorWellKnownEncryptionConfiguration?
    let deprecatedJitsi: VectorWellKnownJitsiConfiguration?
}

// MARK: Decodable
extension VectorWellKnown: Decodable {
    /// JSON keys associated to VectorWellKnown properties
    enum CodingKeys: String, CodingKey {
        case encryption = "io.element.e2ee"
        case jitsi = "io.element.jitsi"
        case migrationBanner = "io.element.migration_banner"
        // Deprecated keys
        case deprecatedEncryption = "im.vector.riot.e2ee"
        case deprecatedJitsi = "im.vector.riot.jitsi"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        encryption = try container.decodeIfPresent(VectorWellKnownEncryptionConfiguration.self, forKey: .encryption)
        jitsi = try container.decodeIfPresent(VectorWellKnownJitsiConfiguration.self, forKey: .jitsi)
        deprecatedEncryption = try container.decodeIfPresent(VectorWellKnownEncryptionConfiguration.self, forKey: .deprecatedEncryption)
        deprecatedJitsi = try container.decodeIfPresent(VectorWellKnownJitsiConfiguration.self, forKey: .deprecatedJitsi)
        // A malformed migration banner section (e.g. not a JSON object) must not prevent the other sections from being parsed.
        migrationBanner = try? container.decodeIfPresent(VectorWellKnownMigrationBannerConfiguration.self, forKey: .migrationBanner)
    }
}

// MARK: - Encryption
struct VectorWellKnownEncryptionConfiguration {
    /// Indicate if E2EE is enabled by default
    let isE2EEByDefaultEnabled: Bool?
    /// Check if secure backup (SSSS) is mandatory.
    let isSecureBackupRequired: Bool?
    /// Methods to use to setup secure backup (SSSS).
    let secureBackupSetupMethods: [VectorWellKnownBackupSetupMethod]?
    /// Outbound keys pre sharing strategy.
    let outboundKeysPreSharingMode: MXKKeyPreSharingStrategy?
}

extension VectorWellKnownEncryptionConfiguration: Decodable {
    /// JSON keys associated to `VectorWellKnownEncryptionConfiguration`
    enum CodingKeys: String, CodingKey {
        case isE2EEByDefaultEnabled = "default"
        case isSecureBackupRequired = "secure_backup_required"
        case secureBackupSetupMethods = "secure_backup_setup_methods"
        case outboundKeysPreSharingMode = "outbound_keys_pre_sharing_mode"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isE2EEByDefaultEnabled = try? container.decode(Bool.self, forKey: .isE2EEByDefaultEnabled)
        isSecureBackupRequired = try? container.decode(Bool.self, forKey: .isSecureBackupRequired)
        let secureBackupSetupMethodsKeys = try? container.decode([String].self, forKey: .secureBackupSetupMethods)
        secureBackupSetupMethods = secureBackupSetupMethodsKeys?.compactMap { VectorWellKnownBackupSetupMethod(key: $0) }
        let outboundKeysPreSharingModeKey = try? container.decode(String.self, forKey: .outboundKeysPreSharingMode)
        outboundKeysPreSharingMode = MXKKeyPreSharingStrategy(key: outboundKeysPreSharingModeKey)
    }
}

// MARK: - Jitsi
struct VectorWellKnownJitsiConfiguration: Decodable {
    /// Default Jitsi server
    let preferredDomain: String?
    /// Override native calling with Jitsi for 1:1 calls.
    let useFor1To1Calls: Bool?
}

// MARK: - Migration Banner

/// Raw content of the `io.element.migration_banner` Well Known section, used to configure the banner
/// inviting users to migrate to Element X.
///
/// The resolution of the default values is done by `HomeserverConfigurationBuilder`.
struct VectorWellKnownMigrationBannerConfiguration: Decodable {
    /// Indicate if the banner should be displayed. `nil` when not provided (defaults to enabled).
    let isEnabled: Bool?
    
    /// JSON keys associated to `VectorWellKnownMigrationBannerConfiguration`
    enum CodingKeys: String, CodingKey {
        case isEnabled = "enabled"
    }
}
