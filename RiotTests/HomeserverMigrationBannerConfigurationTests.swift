// 
// Copyright 2026 Element Creations Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
// Please see LICENSE files in the repository root for full details.
//

import XCTest

@testable import Element

/// Tests the resolution of the migration banner configuration from the homeserver Well Known.
class HomeserverMigrationBannerConfigurationTests: XCTestCase {
    
    private let startDate = BuildSettings.migrationBannerShowWhenNotConfiguredStartDate
    private lazy var beforeStartDate = startDate.addingTimeInterval(-1)
    private lazy var afterStartDate = startDate.addingTimeInterval(24 * 60 * 60)
    
    // MARK: - Helpers
    
    private func buildConfiguration(migrationBannerSection: Any?, now: Date) -> HomeserverMigrationBannerConfiguration {
        var wellKnownDictionary: [String: Any] = [
            "m.homeserver": [
                "base_url": "https://your.homeserver.org"
            ]
        ]
        if let migrationBannerSection = migrationBannerSection {
            wellKnownDictionary["io.element.migration_banner"] = migrationBannerSection
        }
        
        let wellKnown = MXWellKnown(fromJSON: wellKnownDictionary)
        return HomeserverConfigurationBuilder(currentDateProvider: { now }).build(from: wellKnown).migrationBanner
    }
    
    // MARK: - Tests
    
    func testStartDate() {
        let formatter = ISO8601DateFormatter()
        XCTAssertEqual(formatter.string(from: startDate), "2026-11-15T00:00:00Z")
    }
    
    func testMissingSectionBeforeStartDateIsDisabled() {
        XCTAssertFalse(buildConfiguration(migrationBannerSection: nil, now: beforeStartDate).isEnabled)
    }
    
    func testMissingSectionFromStartDateIsEnabled() {
        XCTAssertTrue(buildConfiguration(migrationBannerSection: nil, now: startDate).isEnabled)
        XCTAssertTrue(buildConfiguration(migrationBannerSection: nil, now: afterStartDate).isEnabled)
    }
    
    func testMissingWellKnownFollowsStartDate() {
        XCTAssertFalse(HomeserverConfigurationBuilder(currentDateProvider: { self.beforeStartDate }).build(from: nil).migrationBanner.isEnabled)
        XCTAssertTrue(HomeserverConfigurationBuilder(currentDateProvider: { self.afterStartDate }).build(from: nil).migrationBanner.isEnabled)
    }
    
    func testEmptySectionIsEnabledWhateverTheDate() {
        XCTAssertTrue(buildConfiguration(migrationBannerSection: [String: Any](), now: beforeStartDate).isEnabled)
        XCTAssertTrue(buildConfiguration(migrationBannerSection: [String: Any](), now: afterStartDate).isEnabled)
    }
    
    func testExplicitlyEnabledBeforeStartDate() {
        XCTAssertTrue(buildConfiguration(migrationBannerSection: ["enabled": true], now: beforeStartDate).isEnabled)
    }
    
    func testExplicitlyDisabledAfterStartDate() {
        XCTAssertFalse(buildConfiguration(migrationBannerSection: ["enabled": false], now: afterStartDate).isEnabled)
    }
    
    func testInvalidSectionIsTreatedAsMissing() {
        XCTAssertFalse(buildConfiguration(migrationBannerSection: "not an object", now: beforeStartDate).isEnabled)
        XCTAssertTrue(buildConfiguration(migrationBannerSection: "not an object", now: afterStartDate).isEnabled)
        XCTAssertFalse(buildConfiguration(migrationBannerSection: ["enabled": "false"], now: beforeStartDate).isEnabled)
        XCTAssertTrue(buildConfiguration(migrationBannerSection: ["enabled": "false"], now: afterStartDate).isEnabled)
    }
}
