//
//  Gomoku2AppDelegate.h
//  Gomoku2
//
//  Created by Administrator on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Gomoku2ViewController;

@interface Gomoku2AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Gomoku2ViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Gomoku2ViewController *viewController;


@end

