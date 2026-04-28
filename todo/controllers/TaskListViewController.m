//
//  TaskListViewController 2.h
//  todo
//
//  Created by Abdullh Gaber on 27/04/2026.
//


#import "TaskListViewController.h"
#import "StorageManager.h"
#import "TaskTableViewCell.h"
#import "TaskDetailsViewController.h"
#import "AddEditTaskViewController.h"

@interface TaskListViewController ()
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) NSArray<Task *> *allTasks;
@property (nonatomic, strong) NSArray<Task *> *filteredTasks;

@property (nonatomic, strong) NSArray<Task *> *highPriorityTasks;
@property (nonatomic, strong) NSArray<Task *> *medPriorityTasks;
@property (nonatomic, strong) NSArray<Task *> *lowPriorityTasks;

@property (nonatomic, strong) UIView *emptyStateView;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSString *currentSearchText;

@end

@implementation TaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1.0];
    self.title = @"Tasks";
    [self setupSegmentedControl];
    [self setupTableView];
    [self setupEmptyStateView];
    [self setupSearchBar];
    
    [self generateDummyData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"TaskDataDidUpdate" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.allTasks = [[StorageManager sharedManager] loadTasks];

    [self segmentChanged:self.segmentedControl];
}

- (void)refreshList {
    self.allTasks = [[StorageManager sharedManager] loadTasks];
    [self segmentChanged:self.segmentedControl];
}

- (void)setupSegmentedControl {
    NSArray *items = @[@"All", @"To-Do", @"Progress", @"Done", @"Priority"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.segmentedControl.selectedSegmentTintColor = [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0];
    
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
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.layer.cornerRadius = 12;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.rowHeight = 120;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor systemGray5Color];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.segmentedControl.bottomAnchor constant:16],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
}

- (void)setupSearchBar {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Search tasks";
    self.navigationItem.searchController = self.searchController;
    self.definesPresentationContext = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewTaskTapped)];
}

- (void)setupEmptyStateView {
    self.emptyStateView = [[UIView alloc] init];
    self.emptyStateView.translatesAutoresizingMaskIntoConstraints = NO;
    self.emptyStateView.backgroundColor = [UIColor whiteColor];
    self.emptyStateView.layer.cornerRadius = 12;
    self.emptyStateView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.emptyStateView.layer.shadowOffset = CGSizeMake(0, 4);
    self.emptyStateView.layer.shadowOpacity = 0.05;
    self.emptyStateView.layer.shadowRadius = 10;
    self.emptyStateView.hidden = YES;
    [self.view addSubview:self.emptyStateView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty_state_icon"]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.layer.cornerRadius = 8;
    imageView.layer.masksToBounds = YES;
    [self.emptyStateView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = @"No tasks found";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.15 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.emptyStateView addSubview:titleLabel];
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    subtitleLabel.text = @"Try adjusting your search or filters to\nfind what you're looking for.";
    subtitleLabel.font = [UIFont systemFontOfSize:14];
    subtitleLabel.textColor = [UIColor grayColor];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.numberOfLines = 0;
    [self.emptyStateView addSubview:subtitleLabel];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [addBtn setTitle:@"+ Add New Task" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.35 blue:0.75 alpha:1.0];
    addBtn.layer.cornerRadius = 8;
    addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [addBtn addTarget:self action:@selector(addNewTaskTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.emptyStateView addSubview:addBtn];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.emptyStateView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.emptyStateView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:20],
        [self.emptyStateView.widthAnchor constraintEqualToConstant:300],
        [self.emptyStateView.heightAnchor constraintEqualToConstant:400],
        
        [imageView.topAnchor constraintEqualToAnchor:self.emptyStateView.topAnchor constant:30],
        [imageView.centerXAnchor constraintEqualToAnchor:self.emptyStateView.centerXAnchor],
        [imageView.widthAnchor constraintEqualToConstant:140],
        [imageView.heightAnchor constraintEqualToConstant:140],
        
        [titleLabel.topAnchor constraintEqualToAnchor:imageView.bottomAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:self.emptyStateView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:self.emptyStateView.trailingAnchor constant:-20],
        
        [subtitleLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:10],
        [subtitleLabel.leadingAnchor constraintEqualToAnchor:self.emptyStateView.leadingAnchor constant:20],
        [subtitleLabel.trailingAnchor constraintEqualToAnchor:self.emptyStateView.trailingAnchor constant:-20],
        
        [addBtn.topAnchor constraintEqualToAnchor:subtitleLabel.bottomAnchor constant:30],
        [addBtn.leadingAnchor constraintEqualToAnchor:self.emptyStateView.leadingAnchor constant:20],
        [addBtn.trailingAnchor constraintEqualToAnchor:self.emptyStateView.trailingAnchor constant:-20],
        [addBtn.heightAnchor constraintEqualToConstant:44]
    ]];
}

- (void)addNewTaskTapped {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddEditTaskViewController *editVC = [storyboard instantiateViewControllerWithIdentifier:@"AddEditTaskViewController"];
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)clearFiltersTapped {
    self.segmentedControl.selectedSegmentIndex = 0;
    [self segmentChanged:self.segmentedControl];
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
    [self applyFilters];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.currentSearchText = [searchController.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self applyFilters];
}

- (void)applyFilters {
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    
    if (index == 4) {
        NSPredicate *highPred = [NSPredicate predicateWithFormat:@"priority == %d", TaskPriorityHigh];
        self.highPriorityTasks = [self.allTasks filteredArrayUsingPredicate:highPred];
        
        NSPredicate *medPred = [NSPredicate predicateWithFormat:@"priority == %d", TaskPriorityMedium];
        self.medPriorityTasks = [self.allTasks filteredArrayUsingPredicate:medPred];
        
        NSPredicate *lowPred = [NSPredicate predicateWithFormat:@"priority == %d", TaskPriorityLow];
        self.lowPriorityTasks = [self.allTasks filteredArrayUsingPredicate:lowPred];
        
        if (self.currentSearchText.length > 0) {
            NSPredicate *searchPred = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", self.currentSearchText];
            self.highPriorityTasks = [self.highPriorityTasks filteredArrayUsingPredicate:searchPred];
            self.medPriorityTasks = [self.medPriorityTasks filteredArrayUsingPredicate:searchPred];
            self.lowPriorityTasks = [self.lowPriorityTasks filteredArrayUsingPredicate:searchPred];
        }
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
        
        if (self.currentSearchText.length > 0) {
            NSPredicate *searchPred = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", self.currentSearchText];
            self.filteredTasks = [self.filteredTasks filteredArrayUsingPredicate:searchPred];
        }
    }
    
    [self.tableView reloadData];
    [self updateEmptyStateVisibility];
}

- (void)updateEmptyStateVisibility {
    BOOL isEmpty = NO;
    if (self.segmentedControl.selectedSegmentIndex == 4) {
        isEmpty = (self.highPriorityTasks.count + self.medPriorityTasks.count + self.lowPriorityTasks.count) == 0;
    } else {
        isEmpty = self.filteredTasks.count == 0;
    }
    self.emptyStateView.hidden = !isEmpty;
    self.tableView.hidden = isEmpty;
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
    
    cell.onCheckTapped = ^{
        if (task.status == TaskStatusDone) return;
        
        NSMutableArray *currentTasks = [[[StorageManager sharedManager] loadTasks] mutableCopy];
        for (Task *t in currentTasks) {
            if ([t.taskId isEqualToString:task.taskId]) {
                t.status = TaskStatusDone;
                break;
            }
        }
        [[StorageManager sharedManager] saveTasks:currentTasks];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskDataDidUpdate" object:nil];
    };
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Task *taskToDelete;
        if (self.segmentedControl.selectedSegmentIndex == 4) {
            if (indexPath.section == 0) taskToDelete = self.highPriorityTasks[indexPath.row];
            else if (indexPath.section == 1) taskToDelete = self.medPriorityTasks[indexPath.row];
            else taskToDelete = self.lowPriorityTasks[indexPath.row];
        } else {
            taskToDelete = self.filteredTasks[indexPath.row];
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Task" message:@"Are you sure you want to delete this task?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSMutableArray *currentTasks = [[[StorageManager sharedManager] loadTasks] mutableCopy];
            NSMutableArray *tasksToKeep = [NSMutableArray array];
            for (Task *t in currentTasks) {
                if (![t.taskId isEqualToString:taskToDelete.taskId]) {
                    [tasksToKeep addObject:t];
                }
            }
            [[StorageManager sharedManager] saveTasks:tasksToKeep];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskDataDidUpdate" object:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:deleteAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
