//
//  TableView+SelectionStatus.h
//  DocumentBasedTodo_MartinNash
//
//  Created by Martin Nash on 2/5/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, TableViewSelectionStatus) {
    TableViewSelectionStatusNone,
    TableViewSelectionStatusSingle,
    TableViewSelectionStatusMultiple,
};

@interface NSTableView (SelectionStatus)
@property (readonly) TableViewSelectionStatus selectionStatus;
@property (readonly) BOOL hasSelection;
@end
