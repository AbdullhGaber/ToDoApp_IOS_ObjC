//
//  TaskDetailsViewController.h
//  todo
//
//  Created by Abdullh Gaber on 27/04/2026.
//

#import <UIKit/UIKit.h>
#import "Task.h"
@interface TaskDetailsViewController : UIViewController
@property (nonatomic, strong) Task *task;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priorityBadge;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

