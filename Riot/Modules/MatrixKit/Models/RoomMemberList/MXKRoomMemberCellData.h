/*
Copyright 2024 New Vector Ltd.
Copyright 2015 OpenMarket Ltd

SPDX-License-Identifier: AGPL-3.0-only
Please see LICENSE in the repository root for full details.
 */

#import <Foundation/Foundation.h>
#import <MatrixSDK/MatrixSDK.h>

#import "MXKRoomMemberCellDataStoring.h"

/**
 `MXKRoomMemberCellData` modelised the data for a `MXKRoomMemberTableViewCell` cell.
 */
@interface MXKRoomMemberCellData : MXKCellData <MXKRoomMemberCellDataStoring>

/**
 The matrix session
 */
@property (nonatomic, readonly) MXSession *mxSession;


@end
