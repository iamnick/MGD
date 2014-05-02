//
//  MainMenuOptionsLayer.m
//  mgd
//
//  Created by Nick Stelzer on 4/30/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import "MainMenuOptionsLayer.h"
#import "GameScene.h"
#import "InstructionsScene.h"
#import "AboutScene.h"
#import "cocos2d-ui.h"

@implementation MainMenuOptionsLayer

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Get Screen Size
    CGSize windowSize = [[CCDirector sharedDirector] viewSize];
    
    // Determine Font Size
    float fontSize = windowSize.height / 25;
    
    // New Game Option
    CCButton *newGameButton = [CCButton buttonWithTitle:@"[ New Game ]" fontName:@"Arial Narrow" fontSize:fontSize];
    newGameButton.color = [CCColor colorWithUIColor:[UIColor blackColor]];
    newGameButton.position = ccp(windowSize.width*0.5f, windowSize.height*0.68f);
    [newGameButton setTarget:self selector:@selector(onNewGameClick)];
    [self addChild:newGameButton];
    
    // Instructions Option
    CCButton *instructionsButton = [CCButton buttonWithTitle:@"[ How to Play ]" fontName:@"Arial Narrow" fontSize:fontSize];
    instructionsButton.color = [CCColor colorWithUIColor:[UIColor blackColor]];
    instructionsButton.position = ccp(windowSize.width*0.5f, windowSize.height*0.58f);
    [instructionsButton setTarget:self selector:@selector(onInstructionsClick)];
    [self addChild:instructionsButton];
    
    // Credits Option
    CCButton *aboutButton = [CCButton buttonWithTitle:@"[ About ]" fontName:@"Arial Narrow" fontSize:fontSize];
    aboutButton.color = [CCColor colorWithUIColor:[UIColor blackColor]];
    aboutButton.position = ccp(windowSize.width*0.5f, windowSize.height*0.48f);
    [aboutButton setTarget:self selector:@selector(onAboutClick)];
    [self addChild:aboutButton];
    
    // Done
	return self;
}

- (void)onNewGameClick
{
	CCScene *newGameScene = [[GameScene alloc] init];
	[[CCDirector sharedDirector] pushScene:newGameScene];
}

- (void)onInstructionsClick
{
	CCScene *instructionsScene = [[InstructionsScene alloc] init];
    [[CCDirector sharedDirector] pushScene:instructionsScene];
}

- (void)onAboutClick
{
	CCScene *aboutScene = [[AboutScene alloc] init];
    [[CCDirector sharedDirector] pushScene:aboutScene];
}

@end
