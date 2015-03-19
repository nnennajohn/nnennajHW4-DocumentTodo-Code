//
//  TableView+SelectionStatus.m
//  DocumentBasedTodo_MartinNash
//
//  Created by Martin Nash on 2/5/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

#import "NSTableView+SelectionStatus.h"

@implementation NSTableView (SelectionStatus)

-(TableViewSelectionStatus)selectionStatus
{
    switch (self.selectedRowIndexes.count) {
        case 0:
            return TableViewSelectionStatusNone;
            break;
            
        case 1:
            return TableViewSelectionStatusSingle;
            break;
            
        default:
            return TableViewSelectionStatusMultiple;
            break;
    }
}

-(BOOL)hasSelection
{
    return self.selectedRowIndexes.count > 0;
}

@end
