//
//  GameScene.h
//  mgd
//
//  Created by Nick Stelzer on 4/7/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameScene : CCScene <CCPhysicsCollisionDelegate> {
    
}

+ (GameScene *)scene;
- (id)init;

@end
