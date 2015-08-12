//
//  Cell.h
//  Gomoku2
//
//  Created by Administrator on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell: UIImageView {
	int row;
	int col;
}

@property (readonly, nonatomic) int row;
@property (readonly, nonatomic) int col;


- (id)initWithRow:(int)r Column:(int)c;

@end
