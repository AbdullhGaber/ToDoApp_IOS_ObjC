//
//  TaskTableViewCell.m
//  todo
//
//  Created by Abdullh Gaber on 27/04/2026.
//


#import "TaskTableViewCell.h"

@implementation BadgeLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = UIEdgeInsetsMake(4, 10, 4, 10);
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width + 20, size.height + 8);
}

@end
@implementation TaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.priorityBadge.layer.cornerRadius = 12;
    self.priorityBadge.layer.masksToBounds = YES;
    
    self.statusBadge.layer.cornerRadius = 4;
    self.statusBadge.layer.masksToBounds = YES;
}

- (void)configureWithTask:(Task *)task {
    self.titleLabel.text = task.name;
    self.descriptionLabel.text = task.taskDescription;
    
    switch (task.priority) {
        case TaskPriorityHigh:
            self.priorityBadge.text = @"High";
            self.priorityBadge.textColor = [UIColor colorWithRed:0.78 green:0.31 blue:0.31 alpha:1.0];
            self.priorityBadge.backgroundColor = [UIColor colorWithRed:0.98 green:0.87 blue:0.87 alpha:1.0];
            self.priorityBadge.hidden = NO;
            break;
        case TaskPriorityMedium:
            self.priorityBadge.text = @"Med";
            self.priorityBadge.textColor = [UIColor colorWithRed:0.72 green:0.55 blue:0.21 alpha:1.0];
            self.priorityBadge.backgroundColor = [UIColor colorWithRed:0.99 green:0.95 blue:0.88 alpha:1.0];
            self.priorityBadge.hidden = NO;
            break;
        case TaskPriorityLow:
            self.priorityBadge.text = @"Low";
            self.priorityBadge.textColor = [UIColor colorWithRed:0.29 green:0.62 blue:0.55 alpha:1.0];
            self.priorityBadge.backgroundColor = [UIColor colorWithRed:0.88 green:0.96 blue:0.94 alpha:1.0];
            self.priorityBadge.hidden = NO;
            break;
        default:
            self.priorityBadge.hidden = YES;
            break;
    }
    
    switch (task.status) {
        case TaskStatusToDo:
            self.statusBadge.text = @"To-Do";
            self.statusBadge.textColor = [UIColor colorWithRed:0.43 green:0.44 blue:0.49 alpha:1.0];
            self.statusBadge.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.94 alpha:1.0];
            break;
        case TaskStatusInProgress:
            self.statusBadge.text = @"In Progress";
            self.statusBadge.textColor = [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0];
            self.statusBadge.backgroundColor = [UIColor colorWithRed:0.90 green:0.94 blue:1.0 alpha:1.0];
            break;
        case TaskStatusDone:
            self.statusBadge.text = @"Done";
            self.statusBadge.textColor = [UIColor colorWithRed:0.2 green:0.7 blue:0.3 alpha:1.0];
            self.statusBadge.backgroundColor = [UIColor colorWithRed:0.85 green:0.98 blue:0.9 alpha:1.0];
            break;
    }
}

@end
