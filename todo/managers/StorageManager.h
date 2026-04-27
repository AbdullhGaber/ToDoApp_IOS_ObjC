//
//  StorageManager.h
//  todo
//
//  Created by Abdullh Gaber on 27/04/2026.
//


#import <Foundation/Foundation.h>
#import "Task.h"

@interface StorageManager : NSObject

+ (instancetype)sharedManager;

- (void)saveTasks:(NSArray<Task *> *)tasks;
- (NSArray<Task *> *)loadTasks;

@end
