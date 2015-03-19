//
//  ViewController.m
//  DocumentBasedTodo_MartinNash
//
//  Created by Martin Nash on 2/4/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

#import "ViewController.h"

#import "TodoList.h"
#import "TodoItem.h"
#import "NSTableView+SelectionStatus.h"

@interface ViewController () <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate, NSTextViewDelegate>
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *titleTextField;
@property (unsafe_unretained) IBOutlet NSTextView *contentTextView;
@property (weak) IBOutlet NSButton *insertionButton;
@property (weak) IBOutlet NSButton *deletionButton;
@end

@implementation ViewController



#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelection = YES;
    
    self.titleTextField.focusRingType = NSFocusRingTypeNone;
    
    [self updateTextViewAttributes];
    
    self.titleTextField.delegate = self;
    self.contentTextView.delegate = self;
}

-(void)viewWillAppear
{
    [super viewWillAppear];
    [self updateUI];
}




#pragma mark - NSResponder

-(void)keyDown:(NSEvent *)theEvent
{
    // 51 == backspace
    if (theEvent.keyCode == 51) {
        [self clickedDeleteButton:self.deletionButton];
    } else {
        [super keyDown:theEvent];
    }
}




#pragma mark - Setup

- (void)updateTextViewAttributes
{
    // update paragraph style
    NSMutableParagraphStyle *ps = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    ps.lineSpacing = 5;
    ps.paragraphSpacing = 10;

    
    self.contentTextView.textContainerInset = CGSizeMake(20, 20);
    
    NSDictionary *typingAttributes = @{
        NSForegroundColorAttributeName: [NSColor textColor],
        NSFontAttributeName: [NSFont fontWithName:@"Menlo" size:20],
        NSParagraphStyleAttributeName: ps,
    };
    
    // set up the default text entry
    self.contentTextView.typingAttributes = typingAttributes;
}




#pragma mark - Property overrides

-(void)setTodoList:(TodoList *)todoList
{
    _todoList = todoList;
    [self.tableView reloadData];
}




#pragma mark - Actions

- (IBAction)clickedAddButton:(id)sender
{
    [self.todoList addItemWithTitle:@"New Item"];
    NSIndexSet *lastIndex = [NSIndexSet indexSetWithIndex: self.tableView.numberOfRows];
    [self.tableView insertRowsAtIndexes:lastIndex withAnimation:NSTableViewAnimationSlideDown];
}

- (IBAction)clickedDeleteButton:(id)sender
{
    NSIndexSet *indexes = self.tableView.selectedRowIndexes;
    [self.todoList removeItemsAtIndexes:indexes];
    [self.tableView removeRowsAtIndexes:indexes withAnimation:NSTableViewAnimationEffectFade];
}




#pragma mark - Table View

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.todoList itemCount];
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *tcv = [tableView makeViewWithIdentifier:@"BasicCell" owner:nil];
    tcv.textField.stringValue = [self.todoList itemTitles][row];
    return tcv;
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    [self updateUI];
}

-(TodoItem*)selectedItem
{
    if (self.tableView.selectionStatus == TableViewSelectionStatusSingle) {
        NSUInteger idx = self.tableView.selectedRowIndexes.firstIndex;
        return [self.todoList allItems][idx];
    }
    
    return nil;
}

-(void)updateUI
{
    self.insertionButton.enabled = YES;
    self.deletionButton.enabled = self.tableView.hasSelection;
    self.contentTextView.editable = self.tableView.selectionStatus == TableViewSelectionStatusSingle;
    self.titleTextField.editable = self.tableView.selectionStatus == TableViewSelectionStatusSingle;
    
    if (self.tableView.selectionStatus == TableViewSelectionStatusSingle) {
        TodoItem *item = [self selectedItem];
        if (item) {
            self.titleTextField.stringValue = item.title;
            self.contentTextView.string = item.contents;
        }

    } else {
        self.contentTextView.editable = NO;
        self.contentTextView.string = @"";
        self.titleTextField.stringValue = @"";
    }
}




#pragma mark - Content Text View

-(void)textDidChange:(NSNotification *)notification
{
    if (notification.object == self.contentTextView) {
        [[self selectedItem] setContents:self.contentTextView.string];
        [self.tableView reloadDataForRowIndexes:self.tableView.selectedRowIndexes columnIndexes:[NSIndexSet indexSetWithIndex:0]];
    }
}



#pragma mark - Title Text Field

-(void)controlTextDidChange:(NSNotification *)note
{
    if (note.object == self.titleTextField) {
        [[self selectedItem] setTitle:self.titleTextField.stringValue];
        [self.tableView reloadDataForRowIndexes:self.tableView.selectedRowIndexes columnIndexes:[NSIndexSet indexSetWithIndex:0]];
    }
}

@end
