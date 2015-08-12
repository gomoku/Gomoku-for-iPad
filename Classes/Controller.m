/*
 *  Controller.m: Controller Object of Gomoku.app
 *
 *  Copyright (c) 2000 Nicola Pero <n.pero@mi.flashnet.it>
 *  
 *  Author: Nicola Pero
 *  Date: April, September 2000
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#import "Controller.h"
#include <UIKit/UIKit.h>


@implementation Controller

@synthesize gameView;
@synthesize diffPanel;
@synthesize labelComputer;
@synthesize labelHuman;
@synthesize popoverController;

+ new: (int) cnt GameView:(UIView*)view
{
    return [[self alloc] init: cnt GameView:view];
}

- init: (int) cnt GameView:(UIView*)view
{
	
	gameView = view;
	CGRect winFrame;
 	
	int level;
	
	//set a replacement for NSMatrix
	//essentially array of array of UIImageView
	NSMutableArray *matrix = [NSMutableArray array]; //initialize an empty array
	int i = 0;
	//build cnt * cnt 2D array of Cells
	while (i < cnt) {
		NSMutableArray *row = [NSMutableArray array];
		for (int j = 0; j < cnt; j++) {
			Cell* newCell = [[Cell alloc] initWithRow:i Column:j];
			[gameView addSubview:newCell];
			UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userMove:)];
			tap.numberOfTapsRequired =1;
			[newCell addGestureRecognizer:tap];
			newCell.userInteractionEnabled = YES;
			[row addObject:newCell];
		}
		[matrix addObject:row];
		i++;
	}
	
	winFrame = CGRectMake(0, 0, 600, 600);
	
	board = [[MainBoard alloc] initWithMatrix: matrix];
	
	// @TODO: replace event responder
	//[matrix setTarget: self];
	//[matrix setAction: @selector (userMove:)];
	
	level = 3;
	level = [[NSUserDefaults standardUserDefaults] 
	 integerForKey: @"DifficultyLevel"];
	NSLog(@"%d lvl ",level);
	//level = 3;
	
	diffPanel = [[DifficultyPanel alloc] initWithBoard:board];
	UIPopoverController* popPanelInstance = [[UIPopoverController alloc] initWithContentViewController:diffPanel.panelController];
	[diffPanel.panelController setPopoverController:popPanelInstance];
	popPanelInstance.popoverContentSize = CGSizeMake(200, 400);
	
	
	popoverController = popPanelInstance;
	
	//[popPanelInstance release];
	
	if (level >= 0 && level <= 5)
    {
		[board setDifficultyLevel: level];
    }
	
	
	labelHuman = [[UILabel alloc] init];
	labelComputer = [[UILabel alloc] init];
	labelHuman.frame = CGRectMake(800, 100, 100, 100);
	labelComputer.frame = CGRectMake(800, 450, 100, 100);
	labelHuman.font = [UIFont fontWithName:@"AmericanTypewriter" size:50];
	labelComputer.font = [UIFont fontWithName:@"AmericanTypewriter" size:50];
	
	[gameView addSubview:labelHuman];
	[gameView addSubview:labelComputer];
	[self updateHumanComputerScore];
	
	
	[NSTimer scheduledTimerWithTimeInterval: 2
									 target: self
								   selector: @selector(updateHumanComputerScore)
								   userInfo: nil
									repeats: YES];
	return self;
}


- (void) updateHumanComputerScore{
	labelHuman.text = [NSString stringWithFormat:@"%d",board.scoreHuman];
	labelComputer.text = [NSString stringWithFormat:@"%d",board.scoreComputer];	
}


-(void) dealloc
{
	//TEST_RELEASE (diffPanel);
	// (board);
	[super dealloc];
}


- (void) runDifficultyLevelPanel:(UIBarItem *)sender{
	if (diffPanel == nil)
	{
		diffPanel = [[DifficultyPanel alloc] initWithBoard: board];
	}
	
	//[gameView bringSubviewToFront:[diffPanel getTableView]];
	[diffPanel getTableView].hidden = NO;
	
	[self.popoverController presentPopoverFromBarButtonItem:(UIBarButtonItem*)sender
								   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


- (void) newGame
{
	[board newGame];
}


- (void) userMove: (UIGestureRecognizer*) sender
{
	
	if ([sender.view isKindOfClass: [Cell class]])
    {
		Cell* c = (Cell*)(sender.view);
		//make sure user won't double-tap when we release the tap object
		c.userInteractionEnabled = NO;
		gameView.userInteractionEnabled = NO;
		[board userMoveInRow: c.row column: c.col];
		gameView.userInteractionEnabled = YES;
    }
}

@end

