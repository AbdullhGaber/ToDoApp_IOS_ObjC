//
//  TaskListViewController 2.h
//  todo
//
//  Created by Abdullh Gaber on 27/04/2026.
//


#import "TaskListViewController.h"
#import "StorageManager.h"
#import "Task.h"
#import "TaskTableViewCell.h"
#import "TaskDetailsViewController.h"

@interface TaskListViewController ()
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) NSArray<Task *> *allTasks;
@property (nonatomic, strong) NSArray<Task *> *filteredTasks;

@property (nonatomic, strong) NSArray<Task *> *highPriorityTasks;
@property (nonatomic, strong) NSArray<Task *> *medPriorityTasks;
@property (nonatomic, strong) NSArray<Task *> *lowPriorityTasks;

@end

@implementation TaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1.0];
    self.title = @"Tasks";
    [self setupSegmentedControl];
    [self setupTableView];
    
    [self generateDummyData];
}

- (void)setupSegmentedControl {
    NSArray *items = @[@"All", @"To-Do", @"Progress", @"Done", @"Priority"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.segmentedControl.selectedSegmentTintColor = [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0]; // #007AFF
    
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    
    [self.segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.segmentedControl.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
        [self.segmentedControl.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.segmentedControl.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [self.segmentedControl.heightAnchor constraintEqualToConstant:32]
    ]];
}

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 120;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.segmentedControl.bottomAnchor constant:16],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (void)generateDummyData {
    Task *t1 = [[Task alloc] initWithName:@"Review Q4 Roadmap" description:@"Ensure all dependencies are mapped." priority:TaskPriorityHigh];
    t1.status = TaskStatusToDo;
    
    Task *t2 = [[Task alloc] initWithName:@"Update Onboarding" description:@"Revise welcome screens." priority:TaskPriorityLow];
    t2.status = TaskStatusInProgress;
    
    self.allTasks = @[t1, t2];
    [self segmentChanged:self.segmentedControl];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Task *selectedTask;
    if (self.segmentedControl.selectedSegmentIndex == 4) {
        if (indexPath.section == 0) selectedTask = self.highPriorityTasks[indexPath.row];
        else if (indexPath.section == 1) selectedTask = self.medPriorityTasks[indexPath.row];
        else selectedTask = self.lowPriorityTasks[indexPath.row];
    } else {
        selectedTask = self.filteredTasks[indexPath.row];
    }
    
    [self performSegueWithIdentifier:@"ShowTaskDetails" sender:selectedTask];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowTaskDetails"]) {
        TaskDetailsViewController *destinationVC = segue.destinationViewController;
        destinationVC.task = (Task *)sender;
    }
}

- (void)segmentChanged:(UISegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    
    if (index == 4) {
        NSPredicate *highPred = [NSPredicate predicateWithFormat:@"priority == %d", TaskPriorityHigh];
        self.highPriorityTasks = [self.allTasks filteredArrayUsingPredicate:highPred];
        
        NSPredicate *medPred = [NSPredicate predicateWithFormat:@"priority == %d", TaskPriorityMedium];
        self.medPriorityTasks = [self.allTasks filteredArrayUsingPredicate:medPred];
        
        NSPredicate *lowPred = [NSPredicate predicateWithFormat:@"priority == %d", TaskPriorityLow];
        self.lowPriorityTasks = [self.allTasks filteredArrayUsingPredicate:lowPred];
    } else {
        if (index == 0) {
            self.filteredTasks = self.allTasks;
        } else if (index == 1) {
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"status == %d", TaskStatusToDo];
            self.filteredTasks = [self.allTasks filteredArrayUsingPredicate:pred];
        } else if (index == 2) {
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"status == %d", TaskStatusInProgress];
            self.filteredTasks = [self.allTasks filteredArrayUsingPredicate:pred];
        } else if (index == 3) {
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"status == %d", TaskStatusDone];
            self.filteredTasks = [self.allTasks filteredArrayUsingPredicate:pred];
        }
    }
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.segmentedControl.selectedSegmentIndex == 4) {
        return 3;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.segmentedControl.selectedSegmentIndex == 4) {
        if (section == 0) return @"High Priority";
        if (section == 1) return @"Medium Priority";
        if (section == 2) return @"Low Priority";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segmentedControl.selectedSegmentIndex == 4) {
        if (section == 0) return self.highPriorityTasks.count;
        if (section == 1) return self.medPriorityTasks.count;
        if (section == 2) return self.lowPriorityTasks.count;
    }
    return self.filteredTasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskTableViewCell *cell = (TaskTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    
    Task *task;
    if (self.segmentedControl.selectedSegmentIndex == 4) {
        if (indexPath.section == 0) task = self.highPriorityTasks[indexPath.row];
        else if (indexPath.section == 1) task = self.medPriorityTasks[indexPath.row];
        else task = self.lowPriorityTasks[indexPath.row];
    } else {
        task = self.filteredTasks[indexPath.row];
    }
    
    [cell configureWithTask:task];
    
    return cell;
}

@end
