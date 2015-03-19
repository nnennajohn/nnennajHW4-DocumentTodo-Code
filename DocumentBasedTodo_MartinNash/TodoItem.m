//
//  PCETodoItem.m
//  UWTodoApp
//
//  Created by Martin Nash on 7/8/14.
//  Copyright (c) 2014 Martin Nash (UW). All rights reserved.
//

#import "TodoItem.h"

@implementation TodoItem

+(instancetype)todoItemWithTitle:(NSString *)title
{
    // in a class method, self equals the class.
    TodoItem *item = [[self alloc] init];
    item.title = title;
    return item;
}

- (instancetype)init
{
    return [self initWithTitle:@""];
}

- (instancetype)initWithTitle:(NSString*)title
{
    self = [super init];
    if (self) {
        _title = @"";
        _contents = @"";
    }
    return self;
}

#pragma mark - Custom Description

-(NSString *)description
{
    return [NSString stringWithFormat: @"<%@: %@>", self.className,  self.title];
}



#pragma mark - NSCoding

static NSString * const kTodoItemTitle = @"kTodoItemTitle";
static NSString * const kTodoItemContents  = @"kTodoItemContents";

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:kTodoItemTitle];
    [aCoder encodeObject:self.contents forKey:kTodoItemContents];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:kTodoItemTitle];
        self.contents = [aDecoder decodeObjectForKey:kTodoItemContents];
    }
    return self;
}

@end
