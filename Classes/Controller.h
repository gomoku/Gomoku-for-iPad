/*
 *  Controller.h: Controller Object of Gomoku.app
 *
 *  Copyright (c) 2000 Nicola Pero <n.pero@mi.flashnet.it>
 *  
 *  Author: Nicola Pero
 *  Date: April 2000
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


#import "Cell.h"
#import "Board.h"
#import "MainBoard.h"
#import "DifficultyPanel.h"

@interface Controller : NSObject
{
	MainBoard *board;
	UIView* gameView;
	DifficultyPanel *diffPanel;
	UIPopoverController* popoverController;
	UILabel *labelComputer, *labelHuman;
}

@property (readonly,nonatomic) UIView* gameView;
@property (readonly,nonatomic) DifficultyPanel *diffPanel;
@property (readonly,nonatomic) UILabel *labelComputer;
@property (readonly,nonatomic) UILabel *labelHuman;
@property (readonly,nonatomic,retain) UIPopoverController* popoverController;

+ new: (int) cnt GameView:(UIView*)view;
- init: (int) cnt GameView:(UIView*)view;
//- (void) applicationDidFinishLaunching: (NSNotification *)aNotification;
- (void) runDifficultyLevelPanel:(UIBarItem *)sender;
- (void) newGame;
- (void) updateHumanComputerScore;
@end
