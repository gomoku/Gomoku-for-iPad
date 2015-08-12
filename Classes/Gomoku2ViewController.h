//
//  Gomoku2ViewController.h
//  Gomoku2
//
//  Created by Administrator on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"Controller.h"


@interface Gomoku2ViewController : UIViewController {
	Controller *mainController;
	IBOutlet UIView* gameView;
}

@property (readonly,nonatomic) Controller* mainController;
@property (readonly,nonatomic) UIView *gameView;

- (IBAction) showLevelPanel:(UIBarItem *)sender;
- (IBAction) startNewGame:(UIBarItem *)sender;

@end

