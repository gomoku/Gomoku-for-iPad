//
//  DifficultyPanelTableController.h
//  Gomoku2
//
//  Created by Administrator on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DifficultyPanel.h"

@interface DifficultyPanelTableController : UITableViewController {
	NSArray *dataSrc;
	DifficultyPanelTableController* delegate;
	UIPopoverController* popoverController;
	NSIndexPath* seletedIndex;
}

@property (nonatomic,readonly) NSArray *dataSrc;
@property (nonatomic,assign) DifficultyPanelTableController* delegate;
@property (nonatomic,readwrite,assign) UIPopoverController* popoverController;
@property (nonatomic,readwrite,retain) NSIndexPath* selectedIndex;

- (id)initWithDelegate:(DifficultyPanelTableController *)theDelegate;

- (void) setCellSelectedByIndex:(int)idx;
@end
