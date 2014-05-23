//
//  PostGameNode.h
//  mgd
//
//  Created by Nick Stelzer on 4/16/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <GameKit/GameKit.h>

@interface PostGameNode : CCNode <GKGameCenterControllerDelegate> {
    
}

-(id)initWithRoundScore:(NSNumber*)roundScore andRegHighScores:(NSMutableArray*)regHighScores andNoLLHighScores:(NSMutableArray*)noLLHighScores andAllHSIndex:(int)hsIndex andNoLLIndex:(int)nollIndex scaleFactor:(float)scaleFactor;

@end
