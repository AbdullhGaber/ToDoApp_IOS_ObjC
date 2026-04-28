//
//  TaskListViewController.h
//  todo
//
//  Created by Abdullh Gaber on 27/04/2026.
//


#import <UIKit/UIKit.h>
@interface TaskListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end


