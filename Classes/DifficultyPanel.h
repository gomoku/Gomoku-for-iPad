//
//  DifficultyPanel.h
//  Gomoku2
//
//  Created by Administrator on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainBoard.h"
#import "DifficultyPanelTableController.h"

@class DifficultyPanelTableController;

@interface DifficultyPanel : NSObject<UITableViewDelegate>{
	MainBoard *board;
	DifficultyPanelTableController *panelController;

	
}
@property (nonatomic, retain) DifficultyPanelTableController *panelController;


- (id) initWithBoard: (MainBoard *)b;
- (void) changeLevel: (int)index;
-(UITableView*) getTableView;


@end