//
//  PCETodoList.m
//  UWTodoApp
//
//  Created by Martin Nash on 7/8/14.
//  Copyright (c) 2014 Martin Nash (UW). All rights reserved.
//

#import "TodoList.h"
#import "TodoItem.h"

// class extension
// private properties
@interface TodoList ()
@property (strong, nonatomic) NSMutableArray *itemsArray;
@end

@implementation TodoList


-(instancetype)initWithTitle:(NSString*)title
{
    self = [super init];
    if (self) {
        _itemsArray = [NSMutableArray new];
        _allowsDuplicates = YES;
        _title = [title copy];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithTitle:@""];
}



#pragma mark - Item methods

-(void)addItem:(TodoItem*)item
{
    if (![self canAddItem:item]) {
        return;
    }
    
    [_itemsArray addObject:item];
}

-(void)removeItem:(TodoItem *)item
{
    if (![self hasItemWithTitle:item.title]) {
        return;
    }
    
    NSUInteger itemIndex = [[self itemTitles] indexOfObject:item.title];
    [self.itemsArray removeObjectAtIndex:itemIndex];
}

-(BOOL)canAddItem:(TodoItem*)item
{
    return [self canAddItemWithTitle:item.title];
}

-(BOOL)canRemoveItem:(TodoItem*)item
{
    return [self canRemoveItemWithTitle:item.title];
}


#pragma mark - Item Title methods

-(void)addItemWithTitle:(NSString*)title
{
    // illegal operation; early return
    if (![self canAddItemWithTitle:title]) {
        return;
    }
    
    TodoItem *item = [TodoItem todoItemWithTitle:title];
    [self addItem: item];
}

-(void)removeItemWithTitle:(NSString *)title
{
    if (![self hasItemWithTitle:title]) {
        return;
    }
    
    [self removeItem: [TodoItem todoItemWithTitle:title]];
}

-(BOOL)canAddItemWithTitle:(NSString *)title
{
    return YES;
}

-(BOOL)canRemoveItemWithTitle:(NSString *)title
{
    return [self hasItemWithTitle:title];
}

-(BOOL)hasItemWithTitle:(NSString*)title
{
    return [[self itemTitles] containsObject:title];
}



#pragma mark - Array methods

-(NSArray*)itemTitles
{
    NSMutableArray *itemTitles = [NSMutableArray new];
    [self.itemsArray enumerateObjectsUsingBlock:^(TodoItem *obj, NSUInteger idx, BOOL *stop) {
        [itemTitles addObject:obj.title];
    }];
    return [NSArray arrayWithArray:itemTitles];
}

-(NSArray*)allItems
{
    // create and return new array
    // don't want to return mutable array
    return [NSArray arrayWithArray:self.itemsArray];
}

-(NSUInteger)itemCount
{
    return self.itemsArray.count;
}



-(void)removeItemsAtIndexes:(NSIndexSet*)indexes
{
    [self.itemsArray removeObjectsAtIndexes:indexes];
}



#pragma mark - Convenience

+(instancetype)groceryList
{
    TodoList *list = [[self alloc] initWithTitle:@"Grocery List"];
    [list addItemWithTitle:@"Peanuts"];
    [list addItemWithTitle:@"Bananas"];
    [list addItemWithTitle:@"Yogurt"];
    [list addItemWithTitle:@"Frozen Berries"];
    [list addItemWithTitle:@"Coffee Beans"];
    return list;
}

+(instancetype)airplaneLandingChecklist
{
    TodoList *list = [[self alloc] initWithTitle:@"Airplane Landing Checklist"];
    [list addItemWithTitle:@"Fly to nearby landing zone"];
    [list addItemWithTitle:@"Radio the ATC tower"];
    [list addItemWithTitle:@"Line up plane with runway"];
    [list addItemWithTitle:@"Lower flaps"];
    [list addItemWithTitle:@"Ease back on throttle"];
    return list;
}



#pragma mark - Custom Description

-(NSString*)description
{
    NSMutableString *mutableString = [NSMutableString stringWithString:@"TodoList:\n"];
    for (TodoItem *item in self.itemsArray) {
        [mutableString appendFormat: @"\t%@\n", item];
    }
    return mutableString;
}






#pragma mark - NSCoding

static NSString * const kTodoListTitleKey = @"TodoListTitleKey";
static NSString * const kTodoListAllowsDuplicatesKey = @"TodoListAllowsDuplicatesKey";
static NSString * const kTodoListItemsArrayKey = @"TodoListItemsArrayKey";

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.allowsDuplicates forKey:kTodoListAllowsDuplicatesKey];
    [aCoder encodeObject:self.itemsArray forKey:kTodoListItemsArrayKey];
    [aCoder encodeObject:self.title forKey:kTodoListTitleKey];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:kTodoListTitleKey];
        self.itemsArray = [NSMutableArray arrayWithArray:[aDecoder decodeObjectForKey:kTodoListItemsArrayKey]];
        self.allowsDuplicates = [aDecoder decodeBoolForKey:kTodoListAllowsDuplicatesKey];
    }
    return self;
}

@end
