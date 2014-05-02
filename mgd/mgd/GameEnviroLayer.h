//
//  GameEnviroLayer.h
//  mgd
//
//  Created by Nick Stelzer on 4/30/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameEnviroLayer : CCNode {
    
}

- (id)init;
- (void)startFlyingUp;
- (void)startLanding;

@end
