//
//  GameScene.h
//  mgd
//
//  Created by Nick Stelzer on 4/7/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface GameScene : CCScene <CCPhysicsCollisionDelegate> {
    
}

+ (GameScene *)scene;
- (id)init;
- (void)endOfGameWithTime:(float)timeTaken andIncorrect:(int)incorrect andStreak:(int)streak andLifelinesUsed:(BOOL)llUsed;
- (void)stopBoy;

@end
