//
//  MainBoard.h
//  Gomoku2
//
//  Created by Administrator on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "Cell.h"
#include "Board.h"


@interface MainBoard : NSObject <UIAlertViewDelegate>
{
	/* YES if game is active, NO if not */
	BOOL isGameActive;
	
	/* Difficulty level, between 0 and 5 */
	int difficultyLevel;  
	
	/* The number of turns played.  When it exceeds (size * size) / 2, 
     the game ends [Quits] */
	int turnsPlayed;
	
	/* The main (real) board */
	int    size;
	Board *board;
	
	/* Our screen representation */
	NSArray *matrix;
	
	int scoreHuman;
	int scoreComputer;
}

@property (readonly,nonatomic) NSArray* matrix;
@property (readonly,nonatomic) Board *board;
@property (readonly,nonatomic) int scoreHuman;
@property (readonly,nonatomic) int scoreComputer;



// Initialization depends on the GUI used
- (id) initWithMatrix: (NSArray *)matrix;
/*
 * * The main event routine should report user input 
 * with the following methods.  
 *
 */
// Reset the game board and starts a new game.  Usually invoked when
// the user presses 'NewGame' or similar.  
- (void) newGame;
// Return YES if the board tile in (row i, column j) is free (that is,
// the user can move there); NO otherwise.
- (BOOL) isFreeRow: (int) i  column: (int) j;
// Enter a user move in (row i, column j).  If the tile is not free,
// do nothing.  Otherwise, place a user tile in that position, check
// if user has won, otherwise do a computer move, and check if
// computer has won.
- (void) userMoveInRow: (int) i  column: (int) j;
// Change difficulty level.  
// Valid levels are between 0 and 5.
// It can be safely changed while the game is running; 
// an higher difficulty level will use a better algorithm to 
// compute computer moves.
- (void) setDifficultyLevel: (int) i;
// Return current difficultyLevel
- (int) difficultyLevel;
/* 
 * Methods used to display the board. 
 * Override/rewrite the following methods (and the initWithMatrix: 
 * method) to port the game to another GUI framework.  
 */
// Change contents of (row i, column j) to display tile t (which can
// be nothing, computer or human, see enum above)
- (void) setTile: (tile) t
		   inRow: (int) i  
		  column: (int) j;
// Change contents of (row i, column j) to display a winning tile of
// type t (which can be nothing, computer or human, see enum above).
// This is invoked when one the two players win, to highlight the
// winning combination.
- (void) setWinningTile: (tile) t
				  inRow: (int) i
				 column: (int) j;


- (Cell*) getCellFromMatrixinRow:(int)i Column:(int)j;
- (CGRect) getCellPositionRow:(int)i Column:(int)j;
- (void) showWinningInfoForSide:(tile)win;
@end