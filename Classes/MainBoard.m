//
//  MainBoard.m
//  Gomoku2
//
//  Created by Administrator on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainBoard.h"
#import "Board.m"

@implementation MainBoard

static const CGFloat CELL_WIDTH = 55;
static const CGFloat CELL_HEIGHT = 55;
static const CGFloat BOARD_X_OFFSET = 50;
static const CGFloat BOARD_Y_OFFSET = 60;


@synthesize matrix;
@synthesize board;
@synthesize scoreComputer;
@synthesize scoreHuman;


- (id) initWithMatrix: (NSArray *)m
{
	self = [super init];
	//ASSIGN (matrix, m);
	matrix = [m retain];
	size = [m count];
	board = [Board newWithRows: size ];
	[self newGame];
	scoreHuman = 0;
	scoreComputer = 0;
	return self;
}

- (void) dealloc
{
	//RELEASE (matrix);
	//RELEASE (board);
	[super dealloc];
}


- (void) newGame
{
	int i, j;
	

	/* Reset board */
	[board reset];
	for (i = 0; i < size; i++)
    {
		for (j = 0; j < size; j++)
		{
			
			Cell* c =[self getCellFromMatrixinRow:i Column:j];
			c.userInteractionEnabled = YES;
			[self setTile: nothing
					inRow: i  
				   column: j];
		}    
    }
	turnsPlayed = 0;
	/* Answer to user input */
	isGameActive = YES;
}

- (BOOL) isFreeRow: (int) i  column: (int) j
{
	if ([board tileInRow: i column: j] == nothing)
		return YES;
	else
		return NO;
}

- (void) userMoveInRow: (int) i  column: (int) j
{
	patternPosition pos;
	
	if (isGameActive == NO)
		return;
	
	if ([board tileInRow: i column: j] != nothing)
		return;
	
	[board setTile: human inRow: i column: j];
	[self setTile: human inRow: i column: j];
	pos = [board scanBoardForPattern:humanWonPattern length: 5];
	if (PATTERN_FOUND (pos))
    {
		// Human won
		int a, i, j;
		
		isGameActive = NO;
		i = pos.startRow;
		j = pos.startColumn;
		for (a = 0; a < 5; a++)
		{
			[self setWinningTile: human  inRow: i  column: j];
			i += pos.directionRow;
			j += pos.directionColumn;
		}
		[self showWinningInfoForSide:human];
		//[self panel: _(@"Game Over")  info: _(@"Great! You win!")];
		return;
    }
	
	// NB: Human plays first, and the number of available squares is
	// even, so that if we are here, there still is a void square.
	[board performComputerMove];
	[self setTile: computer  inRow: [board lastRow] 
		   column: [board lastColumn]];	  
	pos = [board scanBoardForPattern: computerWonPattern length: 5];
	if (PATTERN_FOUND (pos))
    {
		// Computer won
		int a, i, j;
		
		isGameActive = NO;
		i = pos.startRow;
		j = pos.startColumn;
		for (a = 0; a < 5; a++)
		{
			[self setWinningTile: computer  inRow: i  column: j];
			i += pos.directionRow;
			j += pos.directionColumn;
		}
		[self showWinningInfoForSide:computer];
		//[self panel: _(@"Game Over")  info: _(@"Sorry, you loose.")];
    }  
	turnsPlayed++;
	if (turnsPlayed >= ((size * size) / 2))
    {
		isGameActive = NO;
		[self showWinningInfoForSide:nothing];
		//[self panel: _(@"Game Over")  info: _(@"Quits")];
    }  
}

- (void) setDifficultyLevel: (int) i
{
	if ((i >=0) && (i <= 5))
    {
		difficultyLevel = i;
		[board setDifficultyLevel: i];
    }
	else
    {
		NSLog(@"Internal Error: unknown difficultyLevel");
    }
}

- (int) difficultyLevel
{
	return difficultyLevel;
}

/* 
 * Methods used to display the board. 
 * Override/rewrite the following methods to port the game 
 * to another GUI framework.
 */
// Change contents of (row i, column j) to display tile t (which can
// be nothing, computer or human, see enum above)
- (void) setTile: (tile) t
		   inRow: (int) i  
		  column: (int) j
{
	Cell *cell;
	NSString *position;
	NSString *imageName;
	
	/* Determine the position of the cell */
	position = @"";
	
	if (i == 0)
    {
		position = @"Top";
    }
	else if (i == size - 1)
    {
		position = @"Bottom";
    }
	
	if (j == 0)
    {
		position = [NSString stringWithFormat: @"%@Left", position];
    }
	else if (j == size - 1)
    {
		position = [NSString stringWithFormat: @"%@Right", position];
    }
	
	switch (t)
    {
		case human:
			imageName = [NSString stringWithFormat: @"Human%@.png", position];
			break;
			
		case computer:
			imageName = [NSString stringWithFormat: @"Computer%@.png", position];
			break;
			
		case nothing:
		default:
			imageName = [NSString stringWithFormat: @"Empty%@.png", position];
			break;
    }
	
	cell = [self getCellFromMatrixinRow:i Column:j];
	[cell setImage:[UIImage imageNamed:imageName]];	
	[cell setFrame:[self getCellPositionRow:i Column:j]];
	[cell setTransform:CGAffineTransformMakeRotation(0.00)];
}


- (CGRect) getCellPositionRow:(int)i Column:(int)j{
	
	CGFloat x = BOARD_X_OFFSET + (i-1)*CELL_WIDTH;
	CGFloat y = BOARD_Y_OFFSET + (j-1)*CELL_HEIGHT;
	return CGRectMake(y, x, CELL_WIDTH, CELL_HEIGHT);
}




- (Cell*) getCellFromMatrixinRow:(int)i Column:(int)j{
	return (Cell*)[(NSArray*)[self.matrix objectAtIndex:i] objectAtIndex:j];
}


// Change contents of (row i, column j) to display a winning tile of
// type t (which can be nothing, computer or human, see enum above).
// This is invoked when one the two players win, to highlight the
// winning combination.
- (void) setWinningTile: (tile) t
				  inRow: (int) i
				 column: (int) j
{
	//highlight the cell of winning
}

// Display an alert to the user through a pop up panel; typically
// invoked as: [self panel: @"Game Over" info: @"Human won"];

- (void) showWinningInfoForSide:(tile)win 
{
	NSString *title, *msg;
	
	switch (win) {
		case human:
			title = @"Congratulations!";
			msg = @"You beat the computer!";
			scoreHuman++;
			break;
		case computer:
			title = @"Sorry...";
			msg = @" You lose to the computer leh...";
			scoreComputer++;
			break;
		case nothing:
			//tie-break
			title = @"Tie!";
			msg = @"The computer cannot beat you!";
			break;
		default:
			title = @"System Error";
			msg = @"iPad is unstable!";
			NSLog(@"debug-impossible win value");
			break;
	}
	
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle: title
						  message: msg
						  delegate: self
						  cancelButtonTitle:@"Review First"
						  otherButtonTitles:nil];
	
	[alert addButtonWithTitle:@"Play again"];
	[alert show];
	[alert release];	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if ([@"Play again" isEqual:[alertView buttonTitleAtIndex:buttonIndex]])
		[self newGame];
}

@end


