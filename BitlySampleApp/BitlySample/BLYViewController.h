//
//  BLYViewController.h
//  BitlySample
//
//  Created by tracy pesin on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BitlyTweetSheet.h"

@interface BLYViewController : UIViewController <BitlyTweetSheetDelegate> 

- (IBAction)displayBitlyTweetSheet:(id)sender;
- (IBAction)displayBitlyTweetSheetAsPopover:(id)sender;
- (IBAction)bitlyTextViewExample:(id)sender;
- (IBAction)bitlyURLShortenerExample:(id)sender;

@property(strong) BitlyTweetSheet *bitlyTweetSheet;
@property(strong) UIPopoverController *popoverController;

@end
