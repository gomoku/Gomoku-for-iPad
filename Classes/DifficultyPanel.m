//
//  DifficultyPanel.m
//  Gomoku2
//
//  Created by Administrator on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DifficultyPanel.h"


@implementation DifficultyPanel

@synthesize	panelController;

- (id) initWithBoard:(MainBoard *)b
{
	self = [self init];
	if (self) {
		panelController = [[DifficultyPanelTableController alloc] initWithDelegate:self];
		panelController.tableView.hidden = YES;
		board = b;
	}
	return self;
}

-(UITableView*) getTableView{
	return panelController.tableView;
}

- (void) changeLevel: (int)level
{
	
	[board setDifficultyLevel: level];
	[panelController setCellSelectedByIndex:level];
	[[NSUserDefaults standardUserDefaults] setInteger: level forKey: @"DifficultyLevel"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)dealloc {
    [super dealloc];
}


@end
