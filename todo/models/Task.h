//
//  Task.h
//  todo
//
//  Created by Abdullh Gaber on 27/04/2026.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TaskPriority) {
    TaskPriorityNone = 0,
    TaskPriorityLow,
    TaskPriorityMedium,
    TaskPriorityHigh
};

typedef NS_ENUM(NSInteger, TaskStatus) {
    TaskStatusToDo = 0,
    TaskStatusInProgress,
    TaskStatusDone
};

@interface Task : NSObject <NSSecureCoding>

@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *taskDescription;
@property (nonatomic, assign) TaskPriority priority;
@property (nonatomic, assign) TaskStatus status;
@property (nonatomic, strong) NSDate *creationDate;

- (instancetype)initWithName:(NSString *)name description:(NSString *)description priority:(TaskPriority)priority;

@end
