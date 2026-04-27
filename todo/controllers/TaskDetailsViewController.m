//
//  TaskDetailsViewController.m
//  todo
//
//  Created by Abdullh Gaber on 27/04/2026.
//

#import "TaskDetailsViewController.h"

@implementation TaskDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.99 alpha:1.0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTapped)];
    self.title = @"Task Details";
    
    [self populateUI];
}

- (void)editTapped {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"AddEditNav"];

//    AddEditTaskViewController *editVC = (AddEditTaskViewController *)navController.topViewController;
//    editVC.taskToEdit = self.task;
    
    [self presentViewController:navController animated:YES completion:nil];
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
}


- (IBAction)markInProgressTapped:(id)sender {
    NSLog(@"Marking as In Progress...");
    // Future logic: Update task status, save to StorageManager, pop view controller
}


- (IBAction)markAsDoneTapped:(id)sender {
    NSLog(@"Marking as Done...");
    // Future logic: Update task status, save to StorageManager, pop view controller
}


- (IBAction)deleteTapped:(id)sender {
    NSLog(@"Deleting task...");
    // Future logic: Remove task from StorageManager, pop view controller
}

@end
