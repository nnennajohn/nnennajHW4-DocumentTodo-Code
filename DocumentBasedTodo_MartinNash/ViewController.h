//
//  ViewController.h
//  DocumentBasedTodo_MartinNash
//
//  Created by Martin Nash on 2/4/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class TodoList;
@interface ViewController : NSViewController
@property (strong, nonatomic) TodoList *todoList;
@end

