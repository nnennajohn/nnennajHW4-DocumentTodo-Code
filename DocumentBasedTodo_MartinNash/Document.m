//
//  Document.m
//  DocumentBasedTodo_MartinNash
//
//  Created by Martin Nash on 2/4/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

#import "Document.h"
#import "TodoList.h"
#import "ViewController.h"

@interface Document ()
@property TodoList *todoList;
@end


// when making a new document
// -[Document init]
// -[Document makeWindowControllers]

// when opening from a file
// -[Document init]
// -[Document readFromData:ofType:error:]
// -[Document makeWindowControllers]

// open and set data
//-[Document init]
//-[Document makeWindowControllers]
//-[ViewController viewDidLoad]
//-[ViewController setTodoList:]
//-[ViewController viewWillAppear]
//-[ViewController viewDidAppear]


@implementation Document

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        self.todoList = [[TodoList alloc] initWithTitle:@"My List"];
    }
    return self;
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (void)makeWindowControllers
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    // Override to return the Storyboard file name of the document.
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSWindowController *wc = [storyboard instantiateControllerWithIdentifier:@"Document Window Controller"];
    [self addWindowController:wc];
 
    // share your todo list with the window controller
    if ([wc.contentViewController isKindOfClass:[ViewController class]]) {
        ((ViewController*)wc.contentViewController).todoList = self.todoList;
    }
    
}




#pragma mark - Save and open

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:self.todoList];
    if (!myData) {
        *outError = [NSError errorWithDomain:@"com.martinjnash.error" code:6789 userInfo:@{ NSLocalizedDescriptionKey: @"Couldn't unarchive the data" }];
        return nil;
    }
    return myData;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    id object = [NSKeyedUnarchiver  unarchiveObjectWithData:data];
    if ([object isKindOfClass:[TodoList class]]) {
        self.todoList = object;
        return YES;
    } else {
        *outError = [NSError errorWithDomain:@"com.martinjnash.badData" code:1234 userInfo:@{ NSLocalizedDescriptionKey: @"Couldn't save the data." }];
        return NO;
    }
}

@end

