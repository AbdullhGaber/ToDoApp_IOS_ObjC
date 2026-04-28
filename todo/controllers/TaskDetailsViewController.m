//
//  TaskDetailsViewController.m
//  todo
//
//  Created by Abdullh Gaber on 27/04/2026.
//

#import "TaskDetailsViewController.h"
#import "AddEditTaskViewController.h"
#import "StorageManager.h"

@implementation TaskDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.99 alpha:1.0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTapped)];
    self.title = @"Task Details";
    
    [self populateUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateUI) name:@"TaskDataDidUpdate" object:nil];
}

- (void)editTapped {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddEditTaskViewController *editVC = [storyboard instantiateViewControllerWithIdentifier:@"AddEditTaskViewController"];
    editVC.taskToEdit = self.task;
    
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)populateUI {
    if (!self.task) return;
    
    self.titleLabel.text = self.task.name;
    self.descriptionLabel.text = self.task.taskDescription;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy"];
    NSString *dateString = [formatter stringFromDate:self.task.creationDate];
    self.dateLabel.text = [NSString stringWithFormat:@"Created %@", dateString];
    
    self.priorityBadge.layer.cornerRadius = 12;
    self.priorityBadge.layer.masksToBounds = YES;
    
    switch (self.task.priority) {
        case TaskPriorityHigh:
            self.priorityBadge.text = @" High Priority ";
            self.priorityBadge.textColor = [UIColor colorWithRed:0.78 green:0.31 blue:0.31 alpha:1.0];
            self.priorityBadge.backgroundColor = [UIColor colorWithRed:0.98 green:0.87 blue:0.87 alpha:1.0];
            break;
        case TaskPriorityMedium:
            self.priorityBadge.text = @" Med Priority ";
            self.priorityBadge.textColor = [UIColor colorWithRed:0.72 green:0.55 blue:0.21 alpha:1.0];
            self.priorityBadge.backgroundColor = [UIColor colorWithRed:0.99 green:0.95 blue:0.88 alpha:1.0];
            break;
        case TaskPriorityLow:
            self.priorityBadge.text = @" Low Priority ";
            self.priorityBadge.textColor = [UIColor colorWithRed:0.29 green:0.62 blue:0.55 alpha:1.0];
            self.priorityBadge.backgroundColor = [UIColor colorWithRed:0.88 green:0.96 blue:0.94 alpha:1.0];
            break;
        default:
            self.priorityBadge.hidden = YES;
            break;
    }
    
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subview;
            NSString *title = [btn titleForState:UIControlStateNormal];
            if ([title containsString:@"Progress"]) {
                btn.enabled = (self.task.status == TaskStatusToDo);
                btn.alpha = btn.enabled ? 1.0 : 0.5;
            } else if ([title containsString:@"Done"]) {
                btn.enabled = (self.task.status != TaskStatusDone);
                btn.alpha = btn.enabled ? 1.0 : 0.5;
            }
        }
    }
}


- (IBAction)markInProgressTapped:(id)sender {
    if (self.task.status != TaskStatusToDo) return;
    
    NSMutableArray *currentTasks = [[[StorageManager sharedManager] loadTasks] mutableCopy];
    for (Task *t in currentTasks) {
        if ([t.taskId isEqualToString:self.task.taskId]) {
            t.status = TaskStatusInProgress;
            self.task.status = TaskStatusInProgress;
            break;
        }
    }
    [[StorageManager sharedManager] saveTasks:currentTasks];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskDataDidUpdate" object:nil];
}


- (IBAction)markAsDoneTapped:(id)sender {
    if (self.task.status == TaskStatusDone) return;
    
    NSMutableArray *currentTasks = [[[StorageManager sharedManager] loadTasks] mutableCopy];
    for (Task *t in currentTasks) {
        if ([t.taskId isEqualToString:self.task.taskId]) {
            t.status = TaskStatusDone;
            self.task.status = TaskStatusDone;
            break;
        }
    }
    [[StorageManager sharedManager] saveTasks:currentTasks];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskDataDidUpdate" object:nil];
}


- (IBAction)deleteTapped:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Task" message:@"Are you sure you want to delete this task?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSMutableArray *currentTasks = [[[StorageManager sharedManager] loadTasks] mutableCopy];
        NSMutableArray *tasksToKeep = [NSMutableArray array];
        for (Task *t in currentTasks) {
            if (![t.taskId isEqualToString:self.task.taskId]) {
                [tasksToKeep addObject:t];
            }
        }
        [[StorageManager sharedManager] saveTasks:tasksToKeep];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskDataDidUpdate" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:deleteAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
