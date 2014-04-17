//
//  PauseScene.m
//  mgd
//
//  Created by Nick Stelzer on 4/16/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import "PauseScene.h"
#import "GameScene.h"
#import "cocos2d.h"

@implementation PauseScene

+ (PauseScene *)scene
{
    return [[self alloc] init];
}

-(id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
	
    // Get Screen Size & Text Scaling Factor
    CGSize windowSize = [[CCDirector sharedDirector] viewSize];
    float textScalingFactor = [[CCDirector sharedDirector] contentScaleFactor];
	CCLOG(@"SCALE: %f", textScalingFactor);
    
	// Background
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];

	// Paused Label
    CCLabelTTF *pausedLabel = [CCLabelTTF labelWithString:@"Game Paused" fontName:@"Marker Felt" fontSize:60.0f/textScalingFactor];
    pausedLabel.position = ccp(windowSize.width*0.50f, windowSize.height*0.84f);
    [self addChild:pausedLabel];
    
	// Resume Button
    CCButton *resumeButton = [CCButton buttonWithTitle:@"[ Resume ]" fontName:@"Arial Narrow" fontSize:42.0f/textScalingFactor];
    resumeButton.position = ccp(windowSize.width*0.5f, windowSize.height*0.5f);
    [resumeButton setTarget:self selector:@selector(onResumeClick:)];
    [self addChild:resumeButton];
	
    // Restart Button
    CCButton *restartButton = [CCButton buttonWithTitle:@"[ Restart ]" fontName:@"Arial Narrow" fontSize:42.0f/textScalingFactor];
    restartButton.position = ccp(windowSize.width*0.5f, windowSize.height*0.42f);
    [restartButton setTarget:self selector:@selector(onRestartClick:)];
    [self addChild:restartButton];
    
    // Done
    return self;
}

/*
 *	Pops pause screen back off the stack, returning to GameScene
 */
-(void)onResumeClick:(id)sender
{
	[[CCDirector sharedDirector] popScene];
}

/*
 *	Replaces existing GameScene with a fresh one for a game restart
 */
-(void)onRestartClick:(id)sender
{
	[[CCDirector sharedDirector] popScene];
    
    CCScene *newGameScene = [[GameScene alloc] init];
    [[CCDirector sharedDirector] replaceScene:newGameScene];
}
@end
