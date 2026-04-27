//
//  AddEditTaskViewController.m
//  todo
//
//  Created by Abdullh Gaber on 27/04/2026.
//

#import "AddEditTaskViewController.h"
#import "StorageManager.h"
#import "Task.h"

@implementation AddEditTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1.0];
    self.title = @"New Task";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTapped)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(saveTapped)];
}

- (void)cancelTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveTapped {
    if (self.nameTextField.text.length == 0) {
        return;
    }
    
    TaskPriority priority = TaskPriorityNone;
    if (self.prioritySegment.selectedSegmentIndex == 0) priority = TaskPriorityHigh;
    else if (self.prioritySegment.selectedSegmentIndex == 1) priority = TaskPriorityMedium;
    else if (self.prioritySegment.selectedSegmentIndex == 2) priority = TaskPriorityLow;
    
    Task *newTask = [[Task alloc] initWithName:self.nameTextField.text
                                   description:self.descriptionTextField.text
                                      priority:priority];
    
    
    NSMutableArray *currentTasks = [[[StorageManager sharedManager] loadTasks] mutableCopy];
    if (!currentTasks) {
        currentTasks = [[NSMutableArray alloc] init];
    }
    [currentTasks addObject:newTask];
    [[StorageManager sharedManager] saveTasks:currentTasks];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
