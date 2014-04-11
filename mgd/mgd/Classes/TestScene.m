//
//  TestScene.m
//  mgd
//
//  Created by Nick Stelzer on 4/3/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import "TestScene.h"


@implementation TestScene
{
    CCSprite *_boySprite;
	CCSprite *_redBalloonSprite;
    CCSprite *_blueBalloonSprite;
    CCSprite *_treeSpriteA;
    CCSprite *_treeSpriteB;
    CCNodeColor *_ground;
    CCPhysicsNode *_physicsWorld;
}

+ (TestScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Set Touch Enabled
    self.userInteractionEnabled = YES;
    
    // Create a colored background (lightskyblue1 - #B0E2FF)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.69f green:0.88f blue:1.0f alpha:1.0f]];
    background.zOrder = -1;
    [self addChild:background];
    
    // Physics
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.debugDraw = NO;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
    // Create Rectangle to Represent the Ground (forestgreen - #228B22)
    _ground = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.13f green:0.54f blue:0.13f alpha:1.0f]];
	_ground.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height*0.05f);
    _ground.position = ccp(0.0f, 0.0f);
    _ground.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _ground.contentSize} cornerRadius:0];
    _ground.physicsBody.collisionType = @"groundCollision";
    _ground.physicsBody.type = CCPhysicsBodyTypeStatic;
    [_physicsWorld addChild:_ground];
    
    // Create Tree Sprites
    _treeSpriteA = [CCSprite spriteWithImageNamed:@"tree1.png"];
    _treeSpriteA.scaleX = 0.55f;
    _treeSpriteA.scaleY = 0.55f;
    _treeSpriteA.position = ccp(self.contentSize.width * 0.4f, self.contentSize.height * 0.05f + _treeSpriteA.boundingBox.size.height/2);
    _treeSpriteA.zOrder = -1;
    [self addChild:_treeSpriteA];
    
    _treeSpriteB = [CCSprite spriteWithImageNamed:@"tree2.png"];
    _treeSpriteB.scaleX = 0.55f;
    _treeSpriteB.scaleY = 0.55f;
    _treeSpriteB.position = ccp(self.contentSize.width * 0.8f, self.contentSize.height * 0.05f + _treeSpriteB.boundingBox.size.height/2);
    _treeSpriteB.zOrder = -1;
    [self addChild:_treeSpriteB];
    
	// Create Boy Sprite
    _boySprite = [CCSprite spriteWithImageNamed:@"boy.png"];
    _boySprite.scaleX = 0.1f;
    _boySprite.scaleY = 0.1f;
	_boySprite.position = ccp(self.contentSize.width * 0.4f, self.contentSize.height * 0.4f);
    _boySprite.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _boySprite.contentSize} cornerRadius:0];
    _boySprite.physicsBody.collisionType = @"boyCollision";
    [_physicsWorld addChild:_boySprite];
    
    // Red Balloon Sprite
    _redBalloonSprite = [CCSprite spriteWithImageNamed:@"balloon_red.png"];
    _redBalloonSprite.position = ccp(self.contentSize.width*0.4f, self.contentSize.height*0.7);
    _redBalloonSprite.scaleX = 0.7f;
    _redBalloonSprite.scaleY = 0.7f;
    [self addChild:_redBalloonSprite];
    
    // Blue Balloon Sprite
    _blueBalloonSprite = [CCSprite spriteWithImageNamed:@"balloon_blue.png"];
    _blueBalloonSprite.position = ccp(self.contentSize.width*0.6f, self.contentSize.width*0.7f);
    _blueBalloonSprite.scaleX = 0.7f;
    _blueBalloonSprite.scaleY = 0.7f;
    //_blueBalloonSprite.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:_blueBalloonSprite.contentSize andCenter:(0,0)];
    [self addChild:_blueBalloonSprite];
   	
    // done
	return self;
}

/*
 * 	Handles All Taps On Screen
 */
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    // Log touch location
    CCLOG(@"Touch Location: %@",NSStringFromCGPoint(touchLoc));
    
    // Red Balloon - Correct Answer
    if (CGRectContainsPoint(_redBalloonSprite.boundingBox, touchLoc)) {
    	[[OALSimpleAudio sharedInstance] playEffect:@"balloon_pop.mp3"];
    }
    
    // Blue Balloon - Incorrect Answer
    if (CGRectContainsPoint(_blueBalloonSprite.boundingBox, touchLoc)) {
    	[[OALSimpleAudio sharedInstance] playEffect:@"wrong_answer.mp3"];
    }
    
    // Boy - Falls to Ground
    if (CGRectContainsPoint(_boySprite.boundingBox, touchLoc)) {
    	// Without Collision Movement
        //CCActionMoveTo *boyFalling = [CCActionMoveTo actionWithDuration:2.0f position:CGPointMake(_boySprite.position.x, ((self.contentSize.height*0.05f) + _boySprite.boundingBox.size.height/2 ))];
        
        // With Collision Movement
    	CCActionMoveTo *boyFalling = [CCActionMoveTo actionWithDuration:2.0f position:CGPointMake(_boySprite.position.x, (self.contentSize.height*0.05f ))];
        [_boySprite runAction:boyFalling];
    }
}

/*
 * Handles Collision of Boy Sprite & Ground 
 */
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair groundCollision:(CCNode *)ground boyCollision:(CCNode *)boy
{
	[boy stopAllActions];
    CCLOG(@"Collision between boy and ground detected.");
    return YES;
}

@end
