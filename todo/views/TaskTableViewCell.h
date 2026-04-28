//
//  TaskTableViewCell.h
//  todo
//
//  Created by Abdullh Gaber on 27/04/2026.
//


#import <UIKit/UIKit.h>
#import "Task.h"


@interface BadgeLabel : UILabel
@end

@interface TaskTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *checkCircle;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet BadgeLabel *priorityBadge;
@property (weak, nonatomic) IBOutlet BadgeLabel *statusBadge;

@property (nonatomic, copy) void (^onCheckTapped)(void);

- (void)configureWithTask:(Task *)task;

@end



