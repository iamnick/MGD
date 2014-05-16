//
//  GameBoardLayer.m
//  mgd
//
//  Created by Nick Stelzer on 4/30/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import "GameBoardLayer.h"
#import "MathProblem.h"
#import "GameScene.h"
#import "PauseScene.h"
#import "TimerNode.h"

@implementation GameBoardLayer
{
	CGSize _windowSize;
    float _problemFontSize, _answerFontSize;
	NSMutableArray *_balloons, *_strings, *_problems, *_answers, *_poppedBalloons;
    MathProblem *_currentProblem;
    int _problemsAnswered;
    int _incorrectAnswers;
    CCLabelTTF *_problemLabel;
    CCSprite *_pauseButton;
    CCSprite *_freezeLifeline, *_skipLifeline, *_fiftyLifeline;
    BOOL _freezeActive, _skipActive, _fiftyActive;
    TimerNode *_timerNode;
    int _maxStreak, _currentStreak;
}

- (id)initWithBoyPosition:(CGPoint)boyPos
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);

	// Initialize Constants
    _windowSize = [[CCDirector sharedDirector] viewSize];
    _problemFontSize = _windowSize.height / 12;
    _answerFontSize = _windowSize.height / 25;
    
    _problems = [[NSMutableArray alloc] init];
    _answers = [[NSMutableArray alloc] init];
    _balloons = [[NSMutableArray alloc] init];
    _strings = [[NSMutableArray alloc] init];
    _poppedBalloons = [[NSMutableArray alloc] init];
    _problemsAnswered = 0;
    _incorrectAnswers = 0;
    _maxStreak = 0;
    _currentStreak = 0;
    
    _skipActive = YES;
    _freezeActive = YES;
    _fiftyActive = YES;
    
    
    // Set Content Size
    self.contentSize = _windowSize;

    // Set Touch Enabled
    self.userInteractionEnabled = YES;
    
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
    CGPoint balloonCoords[] = {ccp(_windowSize.width*0.36f, _windowSize.height*0.72f),
                      		   ccp(_windowSize.width*0.50f, _windowSize.height*0.76f),
                               ccp(_windowSize.width*0.64f, _windowSize.height*0.72f),
                               ccp(_windowSize.width*0.29f, _windowSize.height*0.60f),
                      		   ccp(_windowSize.width*0.43f, _windowSize.height*0.64f),
                      	   	   ccp(_windowSize.width*0.57f, _windowSize.height*0.64f),
                      		   ccp(_windowSize.width*0.71f, _windowSize.height*0.60f),
                      		   ccp(_windowSize.width*0.36f, _windowSize.height*0.50f),
                               ccp(_windowSize.width*0.50f, _windowSize.height*0.54f),
                      		   ccp(_windowSize.width*0.64f, _windowSize.height*0.50f),
                      		   ccp(_windowSize.width*0.43f, _windowSize.height*0.42f),
                      		   ccp(_windowSize.width*0.57f, _windowSize.height*0.42f)};
    
    CGPoint stringEndPoint = ccp(boyPos.x, boyPos.y);
    
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
        newBalloon.zOrder = self.zOrder;
        
        // Create Balloon String
        CGPoint stringStartPoint = ccp(newBalloon.position.x, newBalloon.position.y - newBalloon.boundingBox.size.height*0.42f);
        CCDrawNode *newString = [[CCDrawNode alloc] init];
        [newString drawSegmentFrom:stringStartPoint to:stringEndPoint radius:0.8f color:[CCColor colorWithRed:0.0f green:0.0f blue:0.0f]];
        newString.zOrder = self.zOrder - 1;

        // Create Math Problem
        MathProblem *newProblem;
        switch (arc4random_uniform(3)) {
 			case 0:
            	// Addition Problem
                newProblem = [[MathProblem alloc] initAddition];
                break;
            case 1:
            	// Subtraction Problem
                newProblem = [[MathProblem alloc] initSubtraction];
                break;
            case 2:
            	// Multiplication Problem
                newProblem = [[MathProblem alloc] initMultiplication];
                break;
            case 3:
            	// Division Problem
                newProblem = [[MathProblem alloc] initDivision];
                break;
            default:
            	// Default (should never happen)
                newProblem = [[MathProblem alloc] initAddition];
                break;
        }
        
        CCLOG(@"%@ = %d", newProblem.problemString, newProblem.solution);
		[newProblem setIndex:i];
        [_problems addObject:newProblem];
        
        // Create Answer Label
        NSString *answerString = [[NSString alloc] initWithFormat:@"%d", newProblem.solution];
        CCLabelTTF *newAnswerLabel = [CCLabelTTF labelWithString:answerString fontName:@"Marker Felt" fontSize:_answerFontSize];
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
    
    // Create Lifeline Circles
    _skipLifeline = [CCSprite spriteWithImageNamed:@"skip.png"];
    _skipLifeline.position = ccp(_windowSize.width*0.90f, _windowSize.height*0.70f);
    [self addChild:_skipLifeline];
    
    _freezeLifeline = [CCSprite spriteWithImageNamed:@"freeze.png"];
    _freezeLifeline.position = ccp(_windowSize.width*0.90f, _windowSize.height*0.60f);
    [self addChild:_freezeLifeline];
    
    _fiftyLifeline = [CCSprite spriteWithImageNamed:@"fifty.png"];
    _fiftyLifeline.position = ccp(_windowSize.width*0.90f, _windowSize.height*0.50f);
    [self addChild:_fiftyLifeline];
    
    // Create Top Problem Label
    _problemLabel = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:_problemFontSize]; // TSF
    _problemLabel.position = ccp(_windowSize.width/2, _windowSize.height*0.92f);
    _problemLabel.color = [CCColor colorWithRed:0.0f green:0.0f blue:0.0f];
    _problemLabel.zOrder = self.zOrder;
    
    [self addChild:_problemLabel];
    [self chooseProblem];
    
    // Add Timer Node
    _timerNode = [[TimerNode alloc] init];
    _timerNode.position = ccp(_windowSize.width * 0.90f, _windowSize.height * 0.92f);
    _timerNode.zOrder = self.zOrder;
    [self addChild:_timerNode];
    [_timerNode startTimer];
    
    // Pause Button
    _pauseButton = [CCSprite spriteWithImageNamed:@"pause.png"];
    _pauseButton.position = ccp(_windowSize.width*0.08f, _windowSize.height*0.92f);
    _pauseButton.zOrder = self.zOrder;
    [self addChild:_pauseButton];
	// Done
    return self;
}

/*
 *  Handles taps on the Game Board
 *  Checks to see if taps are on balloons or pause button
 */
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    // Log touch location
    CCLOG(@"Touch Location2: %@",NSStringFromCGPoint(touchLoc));

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
                [_poppedBalloons addObject:[NSNumber numberWithInt:i]];
                
                // Reset opacities of balloons
                CCSprite *balloonToModify;
                CCLabelTTF *answerToModify;
                for (int j = 0; j < [_balloons count]; j++) {
                	balloonToModify = [_balloons objectAtIndex:j];
                	balloonToModify.opacity = 1.0f;
                    answerToModify = [_answers objectAtIndex:j];
                    answerToModify.opacity = 1.0f;
                }
                
                // Continue Timer
                [_timerNode startTimer];
                
                // Streak
            	_currentStreak++;
                if (_currentStreak > _maxStreak) {
                	_maxStreak = _currentStreak;
                }
                
                // Disable 50/50 and skip if just 1 balloon is left
                if (_problemsAnswered == 11) {
                	_fiftyActive = NO;
                    _skipActive = NO;
                    _fiftyLifeline.opacity = 0.5f;
                    _skipLifeline.opacity = 0.5f;
                }
                
                // Check if last balloon was popped
                if (_problemsAnswered < 12) {
                	[self chooseProblem];
                } else {
                	[_problemLabel setString:@""];
                    [_timerNode unscheduleAllSelectors];
                    [(GameScene*)[self parent] endOfGameWithTime:[_timerNode getTime] andIncorrect:_incorrectAnswers andStreak:_maxStreak];
                }
            } else {
            	CCLOG(@"Incorrect Answer");
                _incorrectAnswers++;
                _currentStreak = 0;
                [[OALSimpleAudio sharedInstance] playEffect:@"wrong_answer.mp3"];
            }
        }
    }
    
    // Lifeline Buttons
    if (ccpDistance(_skipLifeline.position, touchLoc) < _skipLifeline.contentSize.width*0.5f && _skipActive) {
    	// Skip
        CCLOG(@"Skip");
        _skipLifeline.opacity = 0.5f;
        _skipActive = NO;
        MathProblem *prevProblem = _currentProblem;
        while ([prevProblem.problemString isEqualToString:_currentProblem.problemString]) {
        	[self chooseProblem];
        }
        
    } else if (ccpDistance(_freezeLifeline.position, touchLoc) < _freezeLifeline.contentSize.width*0.5f && _freezeActive) {
    	// Freeze
        CCLOG(@"Freeze");
        _freezeLifeline.opacity = 0.5f;
        _freezeActive = NO;
        [_timerNode unscheduleAllSelectors];

    } else if (ccpDistance(_fiftyLifeline.position, touchLoc) < _fiftyLifeline.contentSize.width*0.5f && _fiftyActive) {
    	// Fifty
        CCLOG(@"Fifty");
        _fiftyLifeline.opacity = 0.5f;
        _fiftyActive = NO;
        // Find unanswered problems that are incorrect answers
        NSMutableArray *problemsStillActive = [[NSMutableArray alloc] init];
        for (int i = 0; i < _problems.count; i++) {
        	if ([[_problems objectAtIndex:i] answered] == NO && ([[_problems objectAtIndex:i] index] != _currentProblem.index)) {
            	int index = [[_problems objectAtIndex:i] index];
            	[problemsStillActive addObject:[NSNumber numberWithInt:index]];
            }
        }
        // problemsStillActive is now an array of unanswered, incorrect problem indexes (but not visible balloon indexes)
    	
        // Get the 2 indexes of the answers to show for the 50/50
        int incorrect = arc4random_uniform((int)[problemsStillActive count]);
    	int correct = _currentProblem.index;
        while ([_poppedBalloons containsObject:[NSNumber numberWithInt:correct]]) {
        	correct = arc4random_uniform((int)[problemsStillActive count]);
        }
        while ([_poppedBalloons containsObject:[NSNumber numberWithInt:incorrect]] || correct == incorrect) {
        	incorrect = arc4random_uniform((int)[problemsStillActive count]);
        }

        CCLOG(@"incorrect: %d, correct: %d", incorrect, correct);
        // Fade out all balloons except the correct answer and the random incorrect answer
        CCSprite *balloonToModify;
        CCLabelTTF *answerToModify;
        for (int j = 0; j < _problems.count; j++) {
			if ([[_problems objectAtIndex:j] index] != incorrect && [[_problems objectAtIndex:j] index] != correct) {
            	balloonToModify = [_balloons objectAtIndex:j];
                balloonToModify.opacity = 0.50f;
                answerToModify = [_answers objectAtIndex:j];
                answerToModify.opacity = 0.50f;
            }
        }
    }
    
	// Pause Button
    if (CGRectContainsPoint(_pauseButton.boundingBox, touchLoc)) {
    	CCLOG(@"PAUSE");
        //[[CCDirector sharedDirector] pause];
        PauseScene *pauseScene = [[PauseScene alloc] init];
        [[CCDirector sharedDirector] pushScene:pauseScene];
    }
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

@end
