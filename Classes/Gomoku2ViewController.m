//
//  Gomoku2ViewController.m
//  Gomoku2
//
//  Created by Administrator on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Gomoku2ViewController.h"

@implementation Gomoku2ViewController

@synthesize mainController;
@synthesize	gameView;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (IBAction) showLevelPanel:(UIBarItem *)sender{
	[mainController runDifficultyLevelPanel:sender];
}


- (IBAction) startNewGame:(UIBarItem *)sender{
	[mainController newGame];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	int cnt = 13;
	mainController = [Controller new:cnt GameView:gameView];
	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait || 
		[UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown)
		return NO;
	else
		return YES;}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
