// 
// Copyright 2026 Element Creations Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
// Please see LICENSE files in the repository root for full details.
//

import SwiftUI

/// A banner inviting the user to migrate to the new app, displayed at the top of the room list.
struct MigrationBanner: View {
    @Environment(\.theme) private var theme: ThemeSwiftUI
    
    let title: String
    let message: String
    let buttonTitle: String
    let downloadAction: () -> Void
    let closeAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(alignment: .top, spacing: 16) {
                Image(Asset.Images.sunsetBannerIcon.name)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top, spacing: 4) {
                        Text(title)
                            .font(theme.fonts.headline)
                            .foregroundStyle(theme.colors.primaryContent)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Button(action: closeAction) {
                            Image(Asset.Images.closeBanner.name)
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(theme.colors.secondaryContent)
                        }
                        .accessibilityLabel(VectorL10n.close)
                        .accessibilityIdentifier("migrationBannerCloseButton")
                    }

                    Text(message)
                        .font(theme.fonts.subheadline)
                        .foregroundStyle(theme.colors.secondaryContent)
                }
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Button(buttonTitle) {
                downloadAction()
            }
            .buttonStyle(PrimaryActionButtonStyle(font: theme.fonts.bodySB))
            .accessibilityIdentifier("migrationBannerDownloadButton")
        }
        .padding(EdgeInsets(top: 12, leading: 12, bottom: 16, trailing: 12))
        .background(theme.colors.background, in: RoundedRectangle(cornerRadius: 8))
        .shapedBorder(color: theme.colors.quinaryContent, borderWidth: 1, shape: RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .accessibilityIdentifier("migrationBanner")
    }
}

// MARK: - Previews

struct MigrationBanner_Previews: PreviewProvider {
    static var previews: some View {
        MigrationBanner(title: VectorL10n.migrationBannerTitle,
                        message: VectorL10n.migrationBannerBody,
                        buttonTitle: VectorL10n.migrationBannerDownloadButton,
                        downloadAction: { },
                        closeAction: { })
            .theme(.light)
            .previewDisplayName("Light")

        MigrationBanner(title: VectorL10n.migrationBannerTitle,
                        message: VectorL10n.migrationBannerBody,
                        buttonTitle: VectorL10n.migrationBannerDownloadButton,
                        downloadAction: { },
                        closeAction: { })
            .theme(.dark)
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark")
    }
}
