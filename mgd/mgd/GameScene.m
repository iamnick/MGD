//
//  GameScene.m
//  mgd
//
//  Created by Nick Stelzer on 4/7/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import "GameScene.h"
#import "MathProblem.h"
#import "CCAnimation.h"
#import "TimerNode.h"
#import "PostGameNode.h"
#import "PauseScene.h"
#import "GameEnviroLayer.h"
#import "GameBoardLayer.h"

@implementation GameScene
{
	// Screen Width/Height
    CGSize _windowSize;
    float _textScaleFactor;
    
	// Nodes that will need to be accessed later
    CCSprite *_boySprite;
    CCLabelTTF *_problemLabel;
    TimerNode *_timerNode;
    GameEnviroLayer *_enviroLayer;
    GameBoardLayer *_gameBoardLayer;
    
    CCSprite *_pauseButton;
    
    // Physics World
    CCPhysicsNode *_physicsWorld;
    
    // zOrder Constants
    #define Z_BACKGROUND 0
    #define Z_ENVIRO 1
	#define Z_CLOUD 1
    #define Z_GROUND 2
	#define Z_STRING 3
    #define Z_BALLOON 5
    #define Z_BOARD 5
    #define Z_PHYSICS 6
    #define Z_UI 10
}

+ (GameScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Initialize Variables
    _textScaleFactor = [[CCDirector sharedDirector] contentScaleFactor];
    _windowSize = [[CCDirector sharedDirector] viewSize];

    // Background
    CCSprite *background = [CCSprite spriteWithImageNamed:@"background.png"];
    background.position = ccp(_windowSize.width*0.5f, _windowSize.height*0.5f);
    background.zOrder = Z_BACKGROUND;
    [self addChild:background];
    
    // Enviroment Layer
    _enviroLayer = [[GameEnviroLayer alloc] init];
    _enviroLayer.zOrder = Z_ENVIRO;
    [self addChild:_enviroLayer];
    [_enviroLayer startFlyingUp];
    
    // Physics Layer
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.debugDraw = NO;
    _physicsWorld.collisionDelegate = self;
    _physicsWorld.zOrder = Z_PHYSICS;
    [self addChild:_physicsWorld];
    
    // Add Boy Sprite
    _boySprite = [CCSprite spriteWithImageNamed:@"boy_flying1.png"];
    _boySprite.position = ccp(_windowSize.width*0.50f, _windowSize.height*0.14f);
    _boySprite.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _boySprite.contentSize} cornerRadius:0];
    _boySprite.physicsBody.type = CCPhysicsBodyTypeStatic;
    _boySprite.physicsBody.collisionType = @"boyCollision";
    
    // Boy Animation
    NSMutableArray *boyFrames = [NSMutableArray array];
    for (int i = 1; i <= 3; i++) {
    	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"boy_flying%d.png",i]];
        [boyFrames addObject:frame];
    }
    [boyFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"boy_flying2.png"]];
    
    CCAnimation *boyAnimation = [CCAnimation animationWithSpriteFrames:boyFrames delay:0.2f];
    [_boySprite runAction:[CCActionRepeatForever actionWithAction:[CCActionAnimate actionWithAnimation:boyAnimation]]];
    
    [_physicsWorld addChild:_boySprite];
    CCLOG(@"boy z: %ld", (long)_boySprite.zOrder);
    
    // Game Board Layer
    _gameBoardLayer = [[GameBoardLayer alloc] initWithBoyPosition:_boySprite.position];
    _gameBoardLayer.zOrder = Z_BOARD;
    _gameBoardLayer.userInteractionEnabled = YES;
    [self addChild:_gameBoardLayer];
    
    // Add Timer Node
    _timerNode = [[TimerNode alloc] init];
    _timerNode.position = ccp(_windowSize.width * 0.90f, _windowSize.height * 0.92f);
    _timerNode.zOrder = Z_UI;
    [self addChild:_timerNode];
    
	// Set Bird Spawns
    [self schedule:@selector(addBird:) interval:2.0f];
    
    // Done
	return self;
}

/*
 *  Spawns a bird sprite just offscreen on the right side, then moves it left across the screen,
 *  then removes the sprite once it goes offscreen on the left side
 */
- (void)addBird:(CCTime)dt {
	CCSprite *bird = [CCSprite spriteWithImageNamed:@"bird1.png"];
    int minY = bird.contentSize.width / 2;
    int maxY = _windowSize.height - bird.contentSize.width / 2;
    int rangeY = maxY - minY;
    int randomY = (arc4random() % rangeY) + minY;
    
    // Set Bird Properties and Add to Scene
    bird.position = CGPointMake(_windowSize.height + bird.contentSize.height/2, randomY);
    bird.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, bird.contentSize} cornerRadius:0];
    bird.physicsBody.collisionType = @"birdCollision";
    [_physicsWorld addChild:bird];
    
    // Create Movement Action and Remove Action for Sprite
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:6.0f position:CGPointMake(-bird.contentSize.height/2, randomY)];
    CCAction *actionRemove = [CCActionRemove action];
    [bird runAction:[CCActionSequence actionWithArray:@[actionMove, actionRemove]]];
}

/* 
 *  Collision between Bird Sprite and Boy Sprite
 */
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair birdCollision:(CCNode *)bird boyCollision:(CCNode *)boy
{
	CCLOG(@"Collision between bird and boy detected.");
	[bird stopAllActions];
    
    // Make Bird Spin and Fall Off Screen
    CCActionRotateBy *actionSpin = [CCActionRotateBy actionWithDuration:1.0f angle:360.0f];
    [bird runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
    
    CCAction *startFall = [CCActionMoveTo actionWithDuration:1.0f  position:ccp(bird.position.x, -bird.contentSize.height/2)];
    CCAction *actionRemove = [CCActionRemove action];
    [bird runAction:[CCActionSequence actionWithArray:@[startFall, actionRemove]]];

    return YES;
}

/*
 * End of Game method, stops actions/animations, checks for high score (gives option to start new game/return to menu?)
 */
- (void)endOfGame
{

	// Stop time, clouds, and birds from spawning
    [_timerNode unscheduleAllSelectors];
    [_enviroLayer unscheduleAllSelectors];
	[self unscheduleAllSelectors];
    
	// Stop all cloud movement, and start moving them back upwards, also move the ground/trees back up
    [_enviroLayer startLanding];
    
    // Check for High Score & Display Post Game UI
    float highScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"] floatValue];
    float roundScore = [_timerNode getTime];
    PostGameNode *postGame;
    if (roundScore < highScore || highScore == 0) {
        postGame = [[PostGameNode alloc] initWithWin:YES scaleFactor:_textScaleFactor];
        // Store new highscore
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:roundScore] forKey:@"highscore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
		postGame = [[PostGameNode alloc] initWithWin:NO scaleFactor:_textScaleFactor];
    }
    postGame.position = ccp(_windowSize.width*0.50f, _windowSize.height*0.80f);
    postGame.zOrder = Z_UI;
    [self addChild:postGame];
}

/*
 *	Stops the boy animation and changes his sprite to the 'thumbs up' sprite
 */
- (void)stopBoy
{
	[_boySprite stopAllActions];
    [_boySprite setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"boy_landed.png"]];
}
@end
