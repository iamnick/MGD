//
//  PostGameNode.h
//  mgd
//
//  Created by Nick Stelzer on 4/16/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PostGameNode : CCNode {
    
}

-(id)initWithWin:(BOOL)win andScores:(NSArray*)scores scaleFactor:(float)scaleFactor;

@end
