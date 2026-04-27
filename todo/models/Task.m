//
//  Task.m
//  todo
//
//  Created by Abdullh Gaber on 27/04/2026.
//


#import "Task.h"

@implementation Task

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithName:(NSString *)name description:(NSString *)description priority:(TaskPriority)priority {
    self = [super init];
    if (self) {
        _taskId = [[NSUUID UUID] UUIDString];
        _name = name;
        _taskDescription = description;
        _priority = priority;
        _status = TaskStatusToDo;
        _creationDate = [NSDate date];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.taskId forKey:@"taskId"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.taskDescription forKey:@"taskDescription"];
    [coder encodeInteger:self.priority forKey:@"priority"];
    [coder encodeInteger:self.status forKey:@"status"];
    [coder encodeObject:self.creationDate forKey:@"creationDate"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _taskId = [coder decodeObjectOfClass:[NSString class] forKey:@"taskId"];
        _name = [coder decodeObjectOfClass:[NSString class] forKey:@"name"];
        _taskDescription = [coder decodeObjectOfClass:[NSString class] forKey:@"taskDescription"];
        _priority = [coder decodeIntegerForKey:@"priority"];
        _status = [coder decodeIntegerForKey:@"status"];
        _creationDate = [coder decodeObjectOfClass:[NSDate class] forKey:@"creationDate"];
    }
    return self;
}

@end
