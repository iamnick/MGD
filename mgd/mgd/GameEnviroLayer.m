//
//  GameEnviroLayer.m
//  mgd
//
//  Created by Nick Stelzer on 4/30/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import "GameEnviroLayer.h"
#import "GameScene.h"

@implementation GameEnviroLayer
{
	// Window Size
	CGSize _windowSize;
    
    // Ground Sprite, and constants related to it
    CCSprite *_groundSprite;
	CGPoint _groundOffScreen, _groundOnScreen;
    float _groundMoveSpeed;
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
	// Initialize Constants
    _windowSize = [[CCDirector sharedDirector] viewSize];
    _groundOffScreen = ccp(_windowSize.width/2, -_windowSize.height/2);
    _groundOnScreen = ccp(_windowSize.width/2, _windowSize.height*0.26f);
    _groundMoveSpeed = 32.0f*(_windowSize.height*0.26f/_windowSize.height);
    
    // Load Ground Sprite
    _groundSprite = [CCSprite spriteWithImageNamed:@"ground.png"];
    _groundSprite.position = _groundOnScreen;
    [self addChild:_groundSprite];
    
    // Start Cloud Spawning
    [self schedule:@selector(addCloud:) interval:4.0f];
	
    // Done
    return self;
}
/*
 *	Move the ground sprite down off the screen, giving the illusion of lifting off the ground
 */
- (void)startFlyingUp
{
	CCLOG(@"Began Flight Sequence");
	CCAction *moveGroundDown = [CCActionMoveTo actionWithDuration:_groundMoveSpeed position:_groundOffScreen];
    [_groundSprite runAction:moveGroundDown];
}

/*
 *	Move the ground sprite back on screen, giving the illusion of landing
 */
- (void)startLanding
{
	CCLOG(@"Began Landing Sequence.");
    
    // Move Ground Sprite back onto the screen
    CCAction *moveGroundUp = [CCActionMoveTo actionWithDuration:_groundMoveSpeed position:_groundOnScreen];
	CCActionCallBlock *stopEverything = [CCActionCallBlock actionWithBlock:^{
        // Stop any clouds that are still on screen
        CCSprite *cloud;
        for (int i =0; i < [[self children] count]; i++) {
			cloud = [[self children] objectAtIndex:i];
            [cloud stopAllActions];
        }
        [self stopAllActions];
        CCLOG(@"Landing sequence complete.");
        [(GameScene*)[self parent] stopBoy];
        
    }];
    [_groundSprite runAction:[CCActionSequence actionWithArray:@[moveGroundUp, stopEverything]]];
    
    // Find all cloud sprites, stop them, and start them moving back upwards
    CCSprite *child;
    for (int i = 0; i < [[self children] count]; i++) {
        child = [[self children] objectAtIndex:i];
        if (child.isRunningInActiveScene && [child.name isEqualToString:@"cloud"]) {
            [child stopAllActions];
            // Move clouds upward at same speed they were moving downward
            CCAction *moveCloudUp = [CCActionMoveTo actionWithDuration:16.0f*((_windowSize.height-child.position.y)/_windowSize.height) position:ccp(child.position.x, _windowSize.height + child.contentSize.height/2)];
            CCAction *actionRemove = [CCActionRemove action];
            [child runAction:[CCActionSequence actionWithArray:@[moveCloudUp, actionRemove]]];
            
        }
    }
    
}

/*
 *	Spawns a cloud sprite just offscreen at the top, then moves it downward until it is just offscreen
 *  at the bottom, then removes the sprite
 */
- (void)addCloud:(CCTime)dt {
	// Cloud Sprite Filenames
	NSArray *cloudNames = @[@"cloud1.png", @"cloud2.png", @"cloud3.png", @"cloud4.png", @"cloud5.png"];
    
    // Choose Random Cloud Sprite
	int c = arc4random_uniform((u_int32_t)[cloudNames count]);
	CCSprite *cloud = [CCSprite spriteWithImageNamed:[cloudNames objectAtIndex:c]];
    
    // Choose Random X Spawn Point
    int minX = cloud.contentSize.width / 2;
    int maxX = _windowSize.width - cloud.contentSize.width / 2;
    int rangeX = maxX - minX;
    int randomX = (arc4random() % rangeX) + minX;
    
    // Set Cloud Properties and Add to Scene
    cloud.position = CGPointMake(randomX, _windowSize.height + cloud.contentSize.height/2);
    cloud.zOrder = _groundSprite.zOrder - 1;
    cloud.name = @"cloud";
    
    [self addChild:cloud];
    
    // Create Movement Action and Remove Action for Sprite
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:16.0f position:CGPointMake(randomX, -cloud.contentSize.height/2)];
    CCAction *actionRemove = [CCActionRemove action];
    [cloud runAction:[CCActionSequence actionWithArray:@[actionMove, actionRemove]]];
}

@end
