/*
Copyright 2024 New Vector Ltd.
Copyright 2016 OpenMarket Ltd

SPDX-License-Identifier: AGPL-3.0-only
Please see LICENSE in the repository root for full details.
 */

#import "RoomOutgoingAttachmentWithoutSenderInfoBubbleCell.h"

/**
 `RoomOutgoingEncryptedAttachmentWithoutSenderInfoBubbleCell` displays encrypted outgoing attachment with thumbnail, without user's name.
 */
@interface RoomOutgoingEncryptedAttachmentWithoutSenderInfoBubbleCell : RoomOutgoingAttachmentWithoutSenderInfoBubbleCell

@property (weak, nonatomic) IBOutlet UIImageView *encryptionStatusView;

@end
