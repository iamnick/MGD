//
//  MainMenuScene.m
//  mgd
//
//  Created by Nick Stelzer on 4/30/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import "MainMenuScene.h"
//#import "MainMenuEnviroLayer.h"
#import "MainMenuOptionsLayer.h"

@implementation MainMenuScene
{
	// Layers
    CCNode *_enviroLayer, *_optionsLayer;
}

+ (MainMenuScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
	// Get Screen Size
    CGSize windowSize = [[CCDirector sharedDirector] viewSize];

    // Load Spritesheets
    CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
    [sharedFileUtils setiPadSuffix:@"-hd"];
    [sharedFileUtils setiPhoneRetinaDisplaySuffix:@""];
    
    CCSpriteBatchNode *backgroundBgNode;
    backgroundBgNode = [CCSpriteBatchNode batchNodeWithFile:@"background.pvr.ccz"];
    [self addChild:backgroundBgNode];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"background.plist"];
    
    CCSpriteBatchNode *spritesBgNode;
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:@"sprites.png"];
    [self addChild:spritesBgNode];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sprites.plist"];
    
    // Set Background
    CCSprite *background = [CCSprite spriteWithImageNamed:@"background.png"];
    background.position = ccp(windowSize.width*0.5f, windowSize.height*0.5f);
	[self addChild:background];
    
    // Logo
    CCSprite *logo = [CCSprite spriteWithImageNamed:@"logo.png"];
    logo.position = ccp(windowSize.width*0.5f, windowSize.height*0.86f);
    [self addChild:logo];
    
    // Add the ground & trees sprite
    CCSprite *ground = [CCSprite spriteWithImageNamed:@"ground.png"];
    ground.position = ccp(windowSize.width/2, windowSize.height*0.26f);
    [self addChild:ground];
    
    // Boy Sprite
    CCSprite *boySprite = [CCSprite spriteWithImageNamed:@"boy_landed.png"];
    boySprite.position = ccp(windowSize.width*0.5f, windowSize.height*0.14f);
    [self addChild:boySprite];
    
    // Menu Layer
    _optionsLayer = [[MainMenuOptionsLayer alloc] init];
    [self addChild:_optionsLayer];
	
	// Done
	return self;
}

@end
