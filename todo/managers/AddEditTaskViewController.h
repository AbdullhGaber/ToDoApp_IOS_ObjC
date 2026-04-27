//
//  AddEditTaskViewController.h
//  todo
//
//  Created by Abdullh Gaber on 27/04/2026.
//

#import <UIKit/UIKit.h>



@interface AddEditTaskViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;

@end



