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
#import "Achievements.h"

@implementation GameScene
{
	// Screen Width/Height
    CGSize _windowSize;
    float _textScaleFactor;
    
	// Nodes that will need to be accessed later
    CCSprite *_boySprite;
    CCLabelTTF *_problemLabel;
    GameEnviroLayer *_enviroLayer;
    GameBoardLayer *_gameBoardLayer;
    
    CCSprite *_pauseButton;
    
    // Physics World
    CCPhysicsNode *_physicsWorld;
    
    // Achievements Tracker
    Achievements *_achieveTracker;
    
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
    
    // Achievements
   	_achieveTracker = [[Achievements alloc] init];
    
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
 * End of Game method, stops actions/animations, checks for high score
 */
- (void)endOfGameWithTime:(float)timeTaken andIncorrect:(int)incorrect andStreak:(int)streak andLifelinesUsed:(BOOL)llUsed;
{

	// Stop time, clouds, and birds from spawning
    [_enviroLayer unscheduleAllSelectors];
	[self unscheduleAllSelectors];
    
	// Stop all cloud movement, and start moving them back upwards, also move the ground/trees back up
    [_enviroLayer startLanding];
    
    // Calculate Score
    int timeScore = 0;
    if (timeTaken <= 10.0f) {
    	timeScore += 1000;
    } else if (10.0f < timeTaken <= 20.0f) {
    	timeScore += 800;
    } else if (20.0f < timeTaken <= 30.0f) {
    	timeScore += 600;
    } else if (30.0f < timeTaken <= 40.0f) {
    	timeScore += 500;
    } else if (40.0f < timeTaken <= 50.0f) {
    	timeScore += 400;
    } else if (50.0f < timeTaken <= 60.0f) {
    	timeScore += 200;
    } else {
    	timeScore += 100;
    }
    
    int streakScore = streak * 100;
    int incorrectScore = incorrect * -100;
    NSNumber *roundScore = [NSNumber numberWithInt:(timeScore + streakScore + incorrectScore)];
    
    // Check for High Score & Display Post Game UI
    NSMutableArray *topTen = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"highscores"]];
    NSMutableArray *topTenNoLL = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"highscores_noll"]];
    
	CCLOG(@"RoundScore: %d", [roundScore intValue]);
    
    // See if the highscore was among the general list of highscores
    BOOL scoreAddedtoRegHS = NO;
    int regHsIndex = -1;
    if (topTen == nil) {
    	topTen = [[NSMutableArray alloc] init];
        [topTen addObject:roundScore];
        [[NSUserDefaults standardUserDefaults] setObject:topTen forKey:@"highscores"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        scoreAddedtoRegHS = YES;
        regHsIndex = 0;
    } else {
    	for (int i = 0; i < topTen.count; i++) {
    		if ([roundScore intValue] > [[topTen objectAtIndex:i] intValue]) {
                [topTen insertObject:roundScore atIndex:i];
                [[NSUserDefaults standardUserDefaults] setObject:topTen forKey:@"highscores"];
        		[[NSUserDefaults standardUserDefaults] synchronize];
                regHsIndex = i;
                scoreAddedtoRegHS = YES;
                if (topTen.count > 10) {
                	[topTen removeObjectAtIndex:10];
                }
                break;
    		}
    	}
    }
    if (topTen.count < 10 && scoreAddedtoRegHS == NO) {
    	[topTen addObject:roundScore];
        [[NSUserDefaults standardUserDefaults] setObject:topTen forKey:@"highscores"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        regHsIndex = (int)topTen.count - 1;
    }
	
    int noLLHsIndex = -1;
    if (llUsed == NO) {
		BOOL scoreAddedtoNoLLHS = NO;
    	if (topTenNoLL == nil) {
        	topTenNoLL = [[NSMutableArray alloc] init];
        	[topTenNoLL addObject:roundScore];
        	[[NSUserDefaults standardUserDefaults] setObject:topTenNoLL forKey:@"highscores_noll"];
        	[[NSUserDefaults standardUserDefaults] synchronize];
        	scoreAddedtoNoLLHS = YES;
        	noLLHsIndex = 0;
    	} else {
    		for (int i = 0; i < topTenNoLL.count; i++) {
        		if ([roundScore intValue] > [[topTenNoLL objectAtIndex:i] intValue]) {
                	[topTenNoLL insertObject:roundScore atIndex:i];
                	[[NSUserDefaults standardUserDefaults] setObject:topTenNoLL forKey:@"highscores_noll"];
        			[[NSUserDefaults standardUserDefaults] synchronize];
                	noLLHsIndex = i;
                	scoreAddedtoNoLLHS = YES;
                	if (topTenNoLL.count > 10) {
                		[topTenNoLL removeObjectAtIndex:10];
                	}
                	break;
            	}
        	}
    	}
    	if (topTenNoLL.count < 10 && scoreAddedtoNoLLHS == NO) {
    		[topTenNoLL addObject:roundScore];
        	[[NSUserDefaults standardUserDefaults] setObject:topTenNoLL forKey:@"highscores_noll"];
        	[[NSUserDefaults standardUserDefaults] synchronize];
        	noLLHsIndex = (int)topTenNoLL.count - 1;
    	}
    }
	
    // Total Game Counter
    NSNumber *totalGames = [[NSUserDefaults standardUserDefaults] objectForKey:@"total_games"];
    if (totalGames == nil) {
    	totalGames = [NSNumber numberWithInt:0];
    }
    CCLOG(@"TOTAL GAMES: %d", [totalGames intValue]);
    totalGames = [NSNumber numberWithInt:[totalGames intValue] + 1];
    [[NSUserDefaults standardUserDefaults] setObject:totalGames forKey:@"total_games"];
    [[NSUserDefaults standardUserDefaults] synchronize];
	[_achieveTracker updateTotalGamesAchievement:[totalGames intValue]];
    
    PostGameNode *postGame = [[PostGameNode alloc] initWithRoundScore:roundScore andRegHighScores:topTen andNoLLHighScores:topTenNoLL andAllHSIndex:regHsIndex andNoLLIndex:noLLHsIndex scaleFactor:_textScaleFactor];
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
