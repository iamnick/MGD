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
    [self addChild:background];
    
    // Create Ground (forestgreen - #228B22)
    _ground = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.13f green:0.54f blue:0.13f alpha:1.0f]];
	_ground.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height*0.05f);
    _ground.position = ccp(0.0f, 0.0f);
    [self addChild:_ground];
    
	// Boy Sprite
    _boySprite = [CCSprite spriteWithImageNamed:@"boy.png"];
    _boySprite.scaleX = .08;
    _boySprite.scaleY = .08;
    //_boySprite.positionType = CCPositionTypeNormalized;
    _boySprite.position = ccp(self.contentSize.width * 0.4f, self.contentSize.height * 0.4f);
    [self addChild:_boySprite];
    
    // Red Balloon Sprite
    _redBalloonSprite = [CCSprite spriteWithImageNamed:@"balloon_red.png"];
    _redBalloonSprite.position = ccp(self.contentSize.width*0.4f, self.contentSize.height*0.7);
    _redBalloonSprite.scaleX = .7;
    _redBalloonSprite.scaleY = .7;
    [self addChild:_redBalloonSprite];
    
    // Blue Balloon Sprite
    _blueBalloonSprite = [CCSprite spriteWithImageNamed:@"balloon_blue.png"];
    _blueBalloonSprite.position = ccp(self.contentSize.width*0.6f, self.contentSize.width*0.7f);
    _blueBalloonSprite.scaleX = .7;
    _blueBalloonSprite.scaleY = .7;
    //_blueBalloonSprite.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:_blueBalloonSprite.contentSize andCenter:(0,0)];
    [self addChild:_blueBalloonSprite];
    
    // done
	return self;
}

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
    
    // Boy - Falls to Ground (No Collision Yet)
    if (CGRectContainsPoint(_boySprite.boundingBox, touchLoc)) {
        CCActionMoveTo *boyFalling = [CCActionMoveTo actionWithDuration:2.0f position:CGPointMake(_boySprite.position.x, ((self.contentSize.height*0.05f) + _boySprite.boundingBox.size.height/2 ))];
    	[_boySprite runAction:boyFalling];
    }
}

@end
