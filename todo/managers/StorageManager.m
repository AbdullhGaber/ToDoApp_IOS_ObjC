//
//  StorageManager.m
//  todo
//
//  Created by Abdullh Gaber on 27/04/2026.
//


#import "StorageManager.h"

@implementation StorageManager

+ (instancetype)sharedManager {
    static StorageManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSURL *)fileURL {
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = [paths firstObject];
    return [documentsDirectory URLByAppendingPathComponent:@"tasks.data"];
}

- (void)saveTasks:(NSArray<Task *> *)tasks {
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tasks requiringSecureCoding:YES error:&error];
    if (data) {
        [data writeToURL:[self fileURL] atomically:YES];
    } else {
        NSLog(@"Error saving tasks: %@", error);
    }
}

- (NSArray<Task *> *)loadTasks {
    NSData *data = [NSData dataWithContentsOfURL:[self fileURL]];
    if (!data) return @[];
    
    NSError *error;
    NSSet *classes = [NSSet setWithObjects:[NSArray class], [Task class], [NSDate class], [NSString class], nil];
    NSArray *tasks = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:data error:&error];
    
    if (tasks) {
        return tasks;
    } else {
        NSLog(@"Error loading tasks: %@", error);
        return @[];
    }
}

@end