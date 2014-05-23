//
//  MainMenuScene.m
//  mgd
//
//  Created by Nick Stelzer on 4/30/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import "MainMenuScene.h"
#import "cocos2d-ui.h"
#import <GameKit/GameKit.h>
#import "GameScene.h"
#import "InstructionsScene.h"
#import "AboutScene.h"

@implementation MainMenuScene
{
	// Layers
    CCNode *_enviroLayer, *_optionsLayer;
    BOOL _gameCenterEnabled;
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
    
	// Determine Font Size
    float fontSize = windowSize.height / 25;
    
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
    
    // Authenticate User for Game Center
    _gameCenterEnabled = NO;
    [self authenticateLocalPlayer];
    
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

- (void)authenticateLocalPlayer
{
	GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    CCLOG(@"Begain authenticating player");
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
    	if (viewController != nil) {
        	// Present the view controller to log in to Game Center
            [[CCDirector sharedDirector] presentViewController:viewController animated:YES completion:nil];
        } else {
            if ([GKLocalPlayer localPlayer].authenticated) {
            	_gameCenterEnabled = YES;
                // Get default leaderboard identifier
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                	if (error != nil) {
                    	CCLOG(@"%@", [error localizedDescription]);
                    } else {
                    	// _leaderboardIdentifier = leaderboardIdentifier
                        CCLOG(@"%@", leaderboardIdentifier);
                    }
                }];
            } else {
            	// _gameCenterEnabled = NO;
            }
        }
        CCLOG(@"Handler finished.");
    };
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
