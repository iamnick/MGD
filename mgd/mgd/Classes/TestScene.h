//
//  TestScene.h
//  mgd
//
//  Created by Nick Stelzer on 4/3/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface TestScene : CCScene <CCPhysicsCollisionDelegate> {
    
}

+ (TestScene *)scene;
- (id)init;

@end
