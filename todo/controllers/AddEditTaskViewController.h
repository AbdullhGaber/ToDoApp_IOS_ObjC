//
//  AddEditTaskViewController.h
//  todo
//
//  Created by Abdullh Gaber on 27/04/2026.
//

#import <UIKit/UIKit.h>
#import "Task.h"


@interface AddEditTaskViewController : UIViewController

@property (nonatomic, strong, nullable) Task *taskToEdit;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;

@end


