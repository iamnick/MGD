//
//  GameScene.m
//  mgd
//
//  Created by Nick Stelzer on 4/7/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import "GameScene.h"
#import "MathProblem.h"

@implementation GameScene
{
	// Screen Width/Height
    int _screenX, _screenY;
    
	// Sprites that will need to be accessed later
    CCSprite *_boySprite;
    CCLabelTTF *_problemLabel;
	NSMutableArray *_balloons, *_strings, *_problems, *_answers;
    
    // Physics World
    CCPhysicsNode *_physicsWorld;
    
    // Current Math Problem
    MathProblem *_currentProblem;
    int _problemsAnswered;
    
    // zOrder Constants
    #define Z_BACKGROUND 0
	#define Z_CLOUD 1
    #define Z_GROUND 2
	#define Z_STRING 3
    #define Z_PHYSICS 4
    #define Z_BALLOON 5
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
    _problems = [[NSMutableArray alloc] init];
    _answers = [[NSMutableArray alloc] init];
    _balloons = [[NSMutableArray alloc] init];
    _strings = [[NSMutableArray alloc] init];
    _problemsAnswered = 0;
    _screenX = self.contentSize.width;
    _screenY = self.contentSize.height;
    
    // Set Touch Enabled
    self.userInteractionEnabled = YES;
    
    // Background
    CCSprite *background = [CCSprite spriteWithImageNamed:@"background.png"];
    background.position = ccp(_screenX/2, _screenY/2);
    background.zOrder = Z_BACKGROUND;
    [self addChild:background];
    
    // Physics Layer
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.debugDraw = NO;
    _physicsWorld.collisionDelegate = self;
    _physicsWorld.zOrder = Z_PHYSICS;
    [self addChild:_physicsWorld];
    
    // Add Boy
    _boySprite = [CCSprite spriteWithImageNamed:@"boy.png"];
    _boySprite.position = ccp(_screenX*0.50f, _screenY*0.14f);
    _boySprite.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _boySprite.contentSize} cornerRadius:0];
    _boySprite.physicsBody.type = CCPhysicsBodyTypeStatic;
    _boySprite.physicsBody.collisionType = @"boyCollision";
    [_physicsWorld addChild:_boySprite];
    
    // Balloon/String Variables
    NSArray *balloonColors = @[@"balloon_red.png", @"balloon_blue.png", @"balloon_green.png",
                               @"balloon_yellow.png", @"balloon_purple.png", @"balloon_orange.png"];
    
    	/* 	Positioning of Balloons
     	 *  - 4 rows of balloons: 3, 4, 3, 2 (12 Total)
     	 *	- Balloons have 7% of screen width between them horizontally
     	 *  - Rows have 12% of screen width between them vertically, except rows 2 and 3 which is only 10%
     	 *  - End balloons are 4% of screen height lower than middle balloons
     	 *  - Bottom row of balloons are both considered middle balloons
     	 */
    CGPoint balloonCoords[] = {ccp(_screenX*0.36f, _screenY*0.72f),
                      		   ccp(_screenX*0.50f, _screenY*0.76f),
                               ccp(_screenX*0.64f, _screenY*0.72f),
                               ccp(_screenX*0.29f, _screenY*0.60f),
                      		   ccp(_screenX*0.43f, _screenY*0.64f),
                      	   	   ccp(_screenX*0.57f, _screenY*0.64f),
                      		   ccp(_screenX*0.71f, _screenY*0.60f),
                      		   ccp(_screenX*0.36f, _screenY*0.50f),
                               ccp(_screenX*0.50f, _screenY*0.54f),
                      		   ccp(_screenX*0.64f, _screenY*0.50f),
                      		   ccp(_screenX*0.43f, _screenY*0.42f),
                      		   ccp(_screenX*0.57f, _screenY*0.42f)};
    
    CGPoint stringEndPoint = ccp(_boySprite.position.x, _boySprite.position.y + _boySprite.boundingBox.size.height*0.16f);
    
    
    // Create 12 Balloons, Strings, Problems, and Answer Labels
    for (int i = 0; i < 12; i++) {
    
    	// Get Balloon Color
        int colorCount = i;
        while (colorCount > ([balloonColors count] - 1)) {
        	colorCount -= [balloonColors count];
        }
        
        // Create Balloon Sprite
    	CCSprite *newBalloon = [CCSprite spriteWithImageNamed:[balloonColors objectAtIndex:colorCount]];
        newBalloon.position = balloonCoords[i];
        newBalloon.zOrder = Z_BALLOON;
        
        // Create Balloon String
        CGPoint stringStartPoint = ccp(newBalloon.position.x, newBalloon.position.y - newBalloon.boundingBox.size.height*0.42f);
        CCDrawNode *newString = [[CCDrawNode alloc] init];
        [newString drawSegmentFrom:stringStartPoint to:stringEndPoint radius:0.8f color:[CCColor colorWithRed:0.0f green:0.0f blue:0.0f]];
        newString.zOrder = Z_STRING;
        
        // Create Math Problem
        MathProblem *newProblem = [[MathProblem alloc] initAddition];
        CCLOG(@"%@ = %d", newProblem.problemString, newProblem.solution);
		[newProblem setIndex:i];
        [_problems addObject:newProblem];
        
        // Create Answer Label
        NSString *answerString = [[NSString alloc] initWithFormat:@"%d", newProblem.solution];
        CCLabelTTF *newAnswerLabel = [CCLabelTTF labelWithString:answerString fontName:@"Marker Felt" fontSize:42.0f];
        newAnswerLabel.position = ccp(newBalloon.position.x, newBalloon.position.y + newBalloon.contentSize.height*0.10f);
        newAnswerLabel.color = [CCColor colorWithRed:0.0f green:0.0f blue:0.0f];
        newAnswerLabel.zOrder = 10;
        [_answers addObject:newAnswerLabel];
        
        // Add Balloon, String, & Answer Label to Scene & Array
        [self addChild:newBalloon];
        [self addChild:newString];
        [self addChild:newAnswerLabel];
        [_balloons addObject:newBalloon];
        [_strings addObject:newString];
    }
    
    // Create Top Problem Label
    _problemLabel = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:72.0f];
    _problemLabel.position = ccp(_screenX/2, _screenY*0.92f);
    _problemLabel.color = [CCColor colorWithRed:0.0f green:0.0f blue:0.0f];
    _problemLabel.zOrder = 10;
    
    [self addChild:_problemLabel];
    [self chooseProblem];
    
    // Set Cloud Spawns
    [self schedule:@selector(addCloud:) interval:4.0f];
    
    // Set Bird Spawns
    [self schedule:@selector(addBird:) interval:2.0f];
    
    // Done
	return self;
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
    int maxX = _screenX - cloud.contentSize.width / 2;
    int rangeX = maxX - minX;
    int randomX = (arc4random() % rangeX) + minX;
    
    // Set Cloud Properties and Add to Scene
    cloud.position = CGPointMake(randomX, _screenY + cloud.contentSize.height/2);
    cloud.zOrder = Z_CLOUD;
    cloud.name = @"cloud";
    [self addChild:cloud];
    
    // Create Movement Action and Remove Action for Sprite
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:16.0f position:CGPointMake(randomX, -cloud.contentSize.height/2)];
    CCAction *actionRemove = [CCActionRemove action];
    [cloud runAction:[CCActionSequence actionWithArray:@[actionMove, actionRemove]]];
}

/*
 *  Spawns a bird sprite just offscreen on the right side, then moves it left across the screen,
 *  then removes the sprite once it goes offscreen on the left side
 */
- (void)addBird:(CCTime)dt {
	CCSprite *bird = [CCSprite spriteWithImageNamed:@"bird1.png"];
    int minY = bird.contentSize.width / 2;
    int maxY = _screenY - bird.contentSize.width / 2;
    int rangeY = maxY - minY;
    int randomY = (arc4random() % rangeY) + minY;
    
    // Set Bird Properties and Add to Scene
    bird.position = CGPointMake(_screenY + bird.contentSize.height/2, randomY);
    bird.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, bird.contentSize} cornerRadius:0];
    bird.physicsBody.collisionType = @"birdCollision";
    [_physicsWorld addChild:bird];
    
    // Create Movement Action and Remove Action for Sprite
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:6.0f position:CGPointMake(-bird.contentSize.height/2, randomY)];
    CCAction *actionRemove = [CCActionRemove action];
    [bird runAction:[CCActionSequence actionWithArray:@[actionMove, actionRemove]]];
}

/*
 *  Handles taps on the Game Scene
 *  Checks to see if taps are on balloons
 */
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    // Log touch location
    CCLOG(@"Touch Location: %@",NSStringFromCGPoint(touchLoc));

    // Loop through each balloon and check if the touch was inside of it
    for (int i = 0; i < [_balloons count]; i++) {
    	CCSprite *currentBalloon = [_balloons objectAtIndex:i];
        
        // Adjust the Center Point of the hitbox circle to be slightly higher than the centerpoint of sprite
        CGPoint adjustedCenterPoint = ccp(currentBalloon.position.x, currentBalloon.position.y + currentBalloon.contentSize.height*0.10f);
        
        // Check if the touch location is in a circle that represents the hitbox of the balloon sprite
    	if ((ccpDistance(adjustedCenterPoint, touchLoc) < currentBalloon.contentSize.width*0.35f) && [self.children	 indexOfObject:[_balloons objectAtIndex:i]] != NSNotFound){
            CCLOG(@"Touch inside Balloon %d", i);
            
            // Check for correct answer
            MathProblem *problemToCheck = [_problems objectAtIndex:i];
            if (problemToCheck.solution == _currentProblem.solution) {
            	CCLOG(@"Correct Answer!");
                _problemsAnswered++;
                [_currentProblem setAnswered:YES];
                [[OALSimpleAudio sharedInstance] playEffect:@"balloon_pop.mp3"];
                
                // Remove the balloon, string, and answer label that was tapped
                [self removeChild:[_balloons objectAtIndex:i]];
                [self removeChild:[_strings objectAtIndex:i]];
                [self removeChild:[_answers objectAtIndex:i]];
                
                // Check if last balloon was popped
                if (_problemsAnswered < 12) {
                	[self chooseProblem];
                } else {
                	[_problemLabel setString:@""];
                    [self endOfGame];
                }
            } else {
            	CCLOG(@"Incorrect Answer");
                [[OALSimpleAudio sharedInstance] playEffect:@"wrong_answer.mp3"];
            }
        }
    }
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
 *  Chooses new math problem that has not been answered yet, updates problem label with new problem
 */
- (void)chooseProblem {
	BOOL validProblem = NO;
    
    // Choose random problem until an unanswered one has been selected
    int problemIndex;
    MathProblem *problem;
    while (validProblem == NO) {
		problemIndex = arc4random_uniform((u_int32_t)[_problems count]);
		problem = [_problems objectAtIndex:problemIndex];
        if (problem.answered == NO) {
        	validProblem = YES;
            _currentProblem = problem;
        }
    }
    
    // Update Problem Label
    [_problemLabel setString:problem.problemString];
}

- (void)endOfGame {
	// Stop clouds and birds from spawning
	[self unscheduleAllSelectors];
    
	// Stop all cloud movement, and start moving them back upwards
    CCSprite *child;
    for (int i = 0; i < [[self children] count]; i++) {
        child = [[self children] objectAtIndex:i];
        if (child.isRunningInActiveScene && [child.name isEqualToString:@"cloud"]) {
            [child stopAllActions];
            // Move clouds upward at same speed they were moving downward
            CCAction *moveCloudUp = [CCActionMoveTo actionWithDuration:16.0f*((_screenY-child.position.y)/_screenY) position:ccp(child.position.x, _screenY + child.contentSize.height/2)];
            CCAction *actionRemove = [CCActionRemove action];
            [child runAction:[CCActionSequence actionWithArray:@[moveCloudUp, actionRemove]]];
            
        }
    }
    
    // Start bringing up the ground/trees
    CCSprite *ground = [CCSprite spriteWithImageNamed:@"ground.png"];
    ground.position = ccp(_screenX/2, -ground.contentSize.height/2);
    ground.zOrder = Z_GROUND;
    [self addChild:ground];
    float groundMoveSpeed = 32.0f*(_screenY*0.26f/_screenY);
    CCAction *moveGroundUp = [CCActionMoveTo actionWithDuration:groundMoveSpeed position:ccp(_screenX/2, _screenY*0.26f)];
	CCActionCallBlock *stopEverything = [CCActionCallBlock actionWithBlock:^{
        // Stop any clouds that are still on screen
        CCSprite *cloud;
        for (int i =0; i < [[self children] count]; i++) {
			cloud = [[self children] objectAtIndex:i];
            [cloud stopAllActions];
        }
        [self stopAllActions];
        CCLOG(@"Stopping All Actions.");
    }];
    [ground runAction:[CCActionSequence actionWithArray:@[moveGroundUp, stopEverything]]];
}
@end