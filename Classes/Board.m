/*  -*-objc-*-
 *  Board.m: Implementation of the Board Class of the GNUstep  
 *  Gomoku game
 *
 *  Copyright (c) 2000 Nicola Pero <n.pero@mi.flashnet.it>
 *  
 *  Author: Nicola Pero
 *  Date: April 2000
 *
 *  Author: David Relson
 *  Date: September 2000, support for boards of arbitrary size
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
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  */

#import "Board.h"

static const tile humanWonPattern[5] = 
{
  human, human, human, human, human
};

static const tile computerWonPattern[5] = 
{ 
  computer, computer, computer, computer, computer 
};

/*
 * I swear I have beaten (at least once) this engine at all levels.  
 * So, don't be afraid of trying yet another time - it *is* possible 
 * to win, no matter how high the level is. :-)
 */

static const tile humanWonNextPattern[5][5] = 
{ 
  {nothing, human, human, human, human},
  {human, nothing, human, human, human},
  {human, human, nothing, human, human},
  {human, human, human, nothing, human},
  {human, human, human, human, nothing}
};

static const tile computerWonNextPattern[5][5] = 
{ 
  {nothing, computer, computer, computer, computer},
  {computer, nothing, computer, computer, computer},
  {computer, computer, nothing, computer, computer},
  {computer, computer, computer, nothing, computer},
  {computer, computer, computer, computer, nothing}
};

static const tile humanWonFarPattern[4][6] = 
{
  {nothing, nothing, human, human, human, nothing},
  {nothing, human, nothing, human, human, nothing},
  {nothing, human, human, nothing, human, nothing},
  {nothing, human, human, human, nothing, nothing}
};

static const tile computerWonFarPattern[4][6] = 
{
  {nothing, nothing, computer, computer, computer, nothing},
  {nothing, computer, nothing, computer, computer, nothing},
  {nothing, computer, computer, nothing, computer, nothing},
  {nothing, computer, computer, computer, nothing, nothing}
};


#define	BOARD(i, j) board[((i) * size + (j))]
#define	INDEX(i, j) ((i) * size + (j))

@implementation Board

+ (id) newWithRows: (int)cnt
{
    return [[self alloc] initWithRows: cnt];
}

- (id) initWithRows: (int)cnt
{
    size = cnt;
    board = malloc (sizeof(tile *) * size * size);

    [self initBoardConstants];
    
    return self;
}

- (void) initBoardConstants
{
    int startRow, startColumn, position; 

    boardConstants = calloc (size * size, sizeof (int));

    /* The board constant of position (i, j) is the number of winning
       patterns which pass through (i, j) */

    /* We compute it in the most stupid way, by enumerating all
       winning combinations and for each winning combination adding
       one to each board cell belonging to the combination.  
       This is stupid and long, but the code is easy to understand and 
       maintain; nowadays computers are fast enough. */
    
    /* Scan horizontal combinations */
    for (startRow = 0; startRow < size; startRow++)
      {
	for (startColumn = 0; startColumn < (size + 1 - 5); startColumn++)
	  {
	    for (position = 0; position < 5; position++)
	      {
		boardConstants[INDEX (startRow, startColumn + position)]++; 
	      }
	  }
      }

    /* Scan vertical combinations */
    for (startColumn = 0; startColumn < size; startColumn++)
      {
	for (startRow = 0; startRow < (size + 1 - 5); startRow++)
	  {
	    for (position = 0; position < 5; position++)
	      {
		boardConstants[INDEX (startRow + position, startColumn)]++; 
	      }
	  }
      }

    /* Scan NW-SE diagonals. */
    for (startColumn = 0; startColumn < (size + 1 - 5); startColumn++)
      {
	for (startRow = 0; startRow < (size + 1 - 5); startRow++)
	  {
	    for (position = 0; position < 5; position++)
	      {
		boardConstants[INDEX (startRow + position, 
				      startColumn + position)]++;
	      }
	  }
      }

    /* Scan NE-SW diagonals. */
    for (startColumn = (5 - 1); startColumn < size; startColumn++)
      {
	for (startRow = 0; startRow < (size + 1 - 5); startRow++)
	  {
	    for (position = 0; position < 5; position++)
	      {
		boardConstants[INDEX (startRow + position, 
				      startColumn - position)]++;
	      }
	}
      }
}

- (void) dealloc
{
  free (board);
  free (boardConstants);
  [super dealloc];
}

// Initialize, reset, set level
- (void) reset
{
  int i, j;

  for (i = 0; i < size; i++)
    for (j = 0; j < size; j++)
      {
	BOARD (i, j) = nothing;
      }

  last_move_row = -1;
  last_move_col = -1;
}

- (id) copyWithZone: (NSZone*)zone
{
  int i, j;
  Board	*c = [isa allocWithZone: zone];

  c->difficultyLevel = difficultyLevel;

  c->board = malloc (sizeof(tile *) * size * size);
  c->boardConstants = malloc (sizeof(int) * size * size);
  
  for (i = 0; i < size; i++)
    for (j = 0; j< size; j++)
      {
	c->BOARD (i, j) = BOARD (i, j);
	c->boardConstants[INDEX (i, j)] = boardConstants[INDEX (i, j)];
      }
  
  c->last_move_row = last_move_row;  
  c->last_move_col = last_move_col;
  
  return c;
}

- (void) setDifficultyLevel: (int) i
{
  difficultyLevel = i;
}

- (int) difficultyLevel
{
  return difficultyLevel;
}

- (tile) tileInRow: (int) i  column: (int) j
{
  return BOARD (i, j);
}

- (void) setTile: (tile) t inRow: (int) i column: (int) j
{
  BOARD (i, j) = t;
}

- (BOOL) isFreeRow: (int) i  column: (int) j
{
  if (BOARD (i, j) == nothing)
    {
      return YES;
    }
  else 
    {
      return NO;  
    }
  
}

- (BOOL) isPattern: (const tile *)t length: (int)e inPosition: (patternPosition)pos
{
  int a;
  int i, j;

  i = pos.startRow;
  j = pos.startColumn;
  
  for (a = 0; a < e; a++)
    {
      if (t[a] COMPARE_TILE BOARD (i, j))
	{
	  i += pos.directionRow;
	  j += pos.directionColumn;
	}
      else
	{
	  return NO;
	}
    }
  
  return YES;
}

- (patternPosition) scanBoardForPattern: (const tile*)t
				 length: (int)e
{
  // Extremely simple and lossy algorithm and implementation: we
  // consider all possible pattern positions on the board (easy to
  // enumerate), and for each position we compare the pattern to what
  // it is on the board (easy to do).
  patternPosition pos;
  
  // Scan rows.
  pos.directionRow = 0;
  pos.directionColumn = 1;
  for (pos.startRow = 0; pos.startRow < size; pos.startRow++)
    {
      for (pos.startColumn = 0; pos.startColumn < (size + 1 - e); pos.startColumn++)
	{
	  if ([self isPattern: t length: e inPosition: pos] == YES)
	    return pos;
	}
    }

  // Scan columns.
  pos.directionRow = 1;
  pos.directionColumn = 0;
  for (pos.startColumn = 0; pos.startColumn < size; pos.startColumn++)
    {
      for (pos.startRow = 0; pos.startRow < (size + 1 - e); pos.startRow++)
	{
	  if ([self isPattern: t length: e inPosition: pos] == YES)
	    return pos;
	}
    }

  // Scan NW-SE diagonals.
  pos.directionRow = 1;
  pos.directionColumn = 1;
  for (pos.startColumn = 0; pos.startColumn < (size + 1 - e); pos.startColumn++)
    {
      for (pos.startRow = 0; pos.startRow < (size + 1 - e); pos.startRow++)
	{
	  if ([self isPattern: t length: e inPosition: pos] == YES)
	    return pos;
	}
    }

  // Scan NE-SW diagonals.
  pos.directionRow = 1;
  pos.directionColumn = -1;
  for (pos.startColumn = (e - 1); pos.startColumn < size; pos.startColumn++)
    {
      for (pos.startRow = 0; pos.startRow < (size + 1 - e); pos.startRow++)
	{
	  if ([self isPattern: t length: e inPosition: pos] == YES)
	    return pos;
	}
    }

  // Not Found
  pos.startRow = -1;
  return pos;
}

/* 
 * Computes a number representing the strategical importance of the
 * square in row, column.  This is all pretty unprecise and simple,
 * but that's nice - it looks more human. :-) */
- (float) powerOfSquareInRow: (int)row column: (int)column
{
  /* Temporary board to make computations */
  Board *tmp_board;
  patternPosition pos;
  int index;
  float squarePower = 0;

  if (difficultyLevel >= 4)
    {
      tmp_board = [self copy];
      
      /* Put a computer tile in (row, column) */
      tmp_board->BOARD (row, column) = computer;
      
      /* Check how many next computer wins we would have with that move */
      for (index = 0; index < 5; index++)
	{
	  pos = [tmp_board scanBoardForPattern: computerWonNextPattern[index]
			   length: 5];
	  if (PATTERN_FOUND (pos))  
	    {
	      squarePower += 10;
	    }
	}
      
      /* Put a human tile in (row, column) */
      tmp_board->BOARD (row, column) = human;
      
      /* Check how many next human wins we would have with that move */
      for (index = 0; index < 5; index++)
	{
	  pos = [tmp_board scanBoardForPattern: humanWonNextPattern[index]
			   length: 5];
	  if (PATTERN_FOUND (pos))  
	    {
	      squarePower += 10;
	    }
	}
      
      /* If difficultyLevel => 5, do the same with FarPatterns. */
      if (difficultyLevel >= 5)
	{
	  /* Put a computer tile in (row, column) */
	  tmp_board->BOARD (row, column) = computer;
	  
	  /* Check how many far computer wins we would have with that move */
	  for (index = 0; index < 4; index++)
	    {
	      pos = [tmp_board scanBoardForPattern: 
				 computerWonFarPattern[index]
			       length: 6];
	      if (PATTERN_FOUND (pos))  
		{
		  squarePower += 5;
		}
	    }
	  
	  /* Put a human tile in (row, column) */
	  tmp_board->BOARD (row, column) = human;
	  
	  /* Check how many far human wins we would have with that move */
	  for (index = 0; index < 4; index++)
	    {
	      pos = [tmp_board scanBoardForPattern: humanWonFarPattern[index]
			       length: 6];
	      if (PATTERN_FOUND (pos))  
		{
		  squarePower += 5;
		}
	    }
	}

      //RELEASE (tmp_board);
    }
  
  squarePower += boardConstants[INDEX (row, column)];
  
  return squarePower;
}
/*
 * All the following return YES upon succesfully finding a nice move
 * to do; NO otherwise.  */
/* This is always succesful.  Play in a square with lots of tiles
   around (at level 0 - much more refined at higher levels) */
- (BOOL) computerMoveInCrowdedPlace
{
  /* Temporary board to make computations */
  int *tmp_calculate = malloc (sizeof(int) * size * size );
  int max = 0;
  float importance_of_max = 0;
  int i_max = 0;
  int j_max = 0;
  int i,j;
  float tmp_importance;

  /* reset tmp_calculate */
  for (i = 0; i < size; i++)
    {
      for(j = 0; j < size; j++)
	{
	  tmp_calculate[INDEX(i, j)] = 0;
	}    
    }
  
  /* Look for crowded places */
  for (i = 1; i < size - 1; i++)
    {
      for (j = 1; j < size - 1; j++)
	{
	  if (BOARD(i, j) COMPARE_TILE (human | computer))
	    {
	      tmp_calculate[INDEX (i+1, j-1)]++;
	      tmp_calculate[INDEX (i+1, j  )]++;
	      tmp_calculate[INDEX (i+1, j+1)]++;
	      tmp_calculate[INDEX (i,   j-1)]++;
	      tmp_calculate[INDEX (i,   j+1)]++;
	      tmp_calculate[INDEX (i-1, j-1)]++;
	      tmp_calculate[INDEX (i-1, j  )]++;
	      tmp_calculate[INDEX (i-1, j+1)]++;
	    }
	}
    }

  /* avoid squares already occupied */
  for (i = 0; i < size; i++)
    {
      for(j = 0; j < size; j++)
	{	  
	  if (BOARD(i, j) COMPARE_TILE (human | computer))
	    {
	      tmp_calculate[INDEX (i, j)]=0;
	    }
	  else
	    {
	      /* we store here a non-busy cell in case we don't find
		anything better */
	      i_max=i;
	      j_max=j;
	    }
	}    
    }

  /* now we extract the solution */
  for (i = 0; i < size; i++)
    {
      for(j = 0; j < size; j++)
	{
	  if (difficultyLevel >= 3)
	    {
	      if (tmp_calculate[INDEX (i, j)] >= max)
		{
		  tmp_importance = [self powerOfSquareInRow: i column: j];
		  if ((tmp_calculate[INDEX (i, j)] > max) 
		      || (tmp_importance > importance_of_max))
		    {
		      importance_of_max = tmp_importance;
		      max = tmp_calculate[INDEX (i, j)];
		      i_max=i;
		      j_max=j;
		    }
		}
	    }
	  else
	    {
	      /* same without being too smart - just look for the most crowded
		 board square */
	      if (tmp_calculate[INDEX (i, j)] > max)
		{
		  max = tmp_calculate[INDEX (i, j)];
		  i_max = i;
		  j_max = j;
		}
	    }
	}
    }

  BOARD(i_max, j_max) = computer;
  last_move_row = i_max;
  last_move_col = j_max;

  free (tmp_calculate);

  return YES;
}

- (BOOL) computerOrHumanWinNext 
{
  patternPosition pos;
  int index;

  for (index = 0; index < 5; index++)
    {
      pos = [self scanBoardForPattern: computerWonNextPattern[index]
		  length: 5];
      if (PATTERN_FOUND (pos))
	{
	  int a, i, j;
	  
	  i = pos.startRow;
	  j = pos.startColumn;
	  for (a = 0; a < index; a++)
	    {
	      i += pos.directionRow;
	      j += pos.directionColumn;
	    }
	  BOARD(i, j) = computer;
	  last_move_row = i;
	  last_move_col = j;
	  return YES;
	}
    }

  for (index = 0; index < 5; index++)
    {
      pos = [self scanBoardForPattern: humanWonNextPattern[index]
		  length: 5];
      if (PATTERN_FOUND (pos))
	{
	  int a, i, j;
	  
	  i = pos.startRow;
	  j = pos.startColumn;
	  for (a = 0; a < index; a++)
	    {
	      i += pos.directionRow;
	      j += pos.directionColumn;
	    }
	  BOARD(i, j) = computer;
	  last_move_row = i;
	  last_move_col = j;
	  return YES;
	}
    }
  return NO;
}

- (BOOL) computerOrHumanWinFar
{
  patternPosition pos;
  int index;

  for (index = 0; index < 4; index++)
    {
      pos = [self scanBoardForPattern: computerWonFarPattern[index]
		  length: 6];
      if (PATTERN_FOUND (pos))
	{
	  int a, i, j;
	  
	  i = pos.startRow;
	  j = pos.startColumn;
	  for (a = 0; a < (index + 1); a++)
	    {
	      i += pos.directionRow;
	      j += pos.directionColumn;
	    }
	  BOARD(i, j) = computer;
	  last_move_row = i;
	  last_move_col = j;
	  return YES;
	}
    }

  for (index = 0; index < 4; index++)
    {
      pos = [self scanBoardForPattern: humanWonFarPattern[index] length: 6];
      if (PATTERN_FOUND (pos))
	{
	  int a, i, j;
	  
	  i = pos.startRow;
	  j = pos.startColumn;
	  for (a = 0; a < (index + 1); a++)
	    {
	      i += pos.directionRow;
	      j += pos.directionColumn;
	    }
	  BOARD(i, j) = computer;
	  last_move_row = i;
	  last_move_col = j;
	  return YES;
	}
    }
  return NO;
}

- (void) performComputerMove
{
  switch (difficultyLevel)
    {
    case 5:
    case 4:
    case 3:
      if ([self computerOrHumanWinNext] == YES)
	{
	  break;
	}
      if ([self computerOrHumanWinFar] == YES)
	{
	  break;
	}
      /* All the refinement for higher levels goes here */
      [self computerMoveInCrowdedPlace];
      break;    
    case 2:
      if ([self computerOrHumanWinNext] == YES)
	{
	  break;
	}
      if ([self computerOrHumanWinFar] == YES)
	{
	  break;
	}
      [self computerMoveInCrowdedPlace];
      break;    
    case 1:
      if ([self computerOrHumanWinNext] == YES)
	{
	  break;
	}
      /* else fall back on level 0 strategy */
    case 0:
    default:
      [self computerMoveInCrowdedPlace];
      break;    
    }
  
  return;
}
/* Last row and column computer moved to */
- (int) lastRow
{
  return last_move_row;
}

- (int) lastColumn
{
  return last_move_col;
}

@end

