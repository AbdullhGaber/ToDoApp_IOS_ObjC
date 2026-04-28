//
//  AddEditTaskViewController.m
//  todo
//
//  Created by Abdullh Gaber on 27/04/2026.
//

#import "AddEditTaskViewController.h"
#import "StorageManager.h"

@implementation AddEditTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1.0];
    
    self.title = self.taskToEdit ? @"Edit Task" : @"New Task";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:(self.taskToEdit ? @"Save" : @"Add") style:UIBarButtonItemStyleDone target:self action:@selector(saveTapped)];
    
    if (self.taskToEdit) {
        self.nameTextField.text = self.taskToEdit.name;
        self.notesTextView.text = self.taskToEdit.taskDescription;
        
        if (self.taskToEdit.priority == TaskPriorityHigh) self.prioritySegment.selectedSegmentIndex = 1;
        else if (self.taskToEdit.priority == TaskPriorityMedium) self.prioritySegment.selectedSegmentIndex = 2;
        else if (self.taskToEdit.priority == TaskPriorityLow) self.prioritySegment.selectedSegmentIndex = 3;
        else self.prioritySegment.selectedSegmentIndex = 0;
    }
}

- (void)saveTapped {
    NSString *trimmedName = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedName.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Information" message:@"Please fill in the task name to continue." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (self.taskToEdit) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm Edit" message:@"Are you sure you want to save these changes?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self performSave];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:saveAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self performSave];
    }
}

- (void)performSave {
    
    TaskPriority selectedPriority = TaskPriorityNone;
    if (self.prioritySegment.selectedSegmentIndex == 1) selectedPriority = TaskPriorityHigh;
    else if (self.prioritySegment.selectedSegmentIndex == 2) selectedPriority = TaskPriorityMedium;
    else if (self.prioritySegment.selectedSegmentIndex == 3) selectedPriority = TaskPriorityLow;
    
    NSMutableArray *currentTasks = [[[StorageManager sharedManager] loadTasks] mutableCopy];
    if (!currentTasks) currentTasks = [[NSMutableArray alloc] init];
    
    if (self.taskToEdit) {
        self.taskToEdit.name = self.nameTextField.text;
        self.taskToEdit.taskDescription = self.notesTextView.text;
        self.taskToEdit.priority = selectedPriority;
        
        for (Task *t in currentTasks) {
            if ([t.taskId isEqualToString:self.taskToEdit.taskId]) {
                t.name = self.nameTextField.text;
                t.taskDescription = self.notesTextView.text;
                t.priority = selectedPriority;
                break;
            }
        }
    } else {
        Task *newTask = [[Task alloc] initWithName:self.nameTextField.text
                                       description:self.notesTextView.text
                                          priority:selectedPriority];
        [currentTasks addObject:newTask];
    }
    
    [[StorageManager sharedManager] saveTasks:currentTasks];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskDataDidUpdate" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
