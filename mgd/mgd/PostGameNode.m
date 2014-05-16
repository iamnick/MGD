//
//  PostGameNode.m
//  mgd
//
//  Created by Nick Stelzer on 4/16/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import "PostGameNode.h"


@implementation PostGameNode

-(id)initWithWin:(BOOL)win andScores:(NSArray*)scores scaleFactor:(float)scaleFactor
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
  	
    // Screen Size
    CGSize windowSize = [[CCDirector sharedDirector] viewSize];
    
    // Label to show if high score was beaten or not
    NSString *labelString = [[NSString alloc] init];
    if (win == YES) {
    	labelString = @"Congratulations! New High Score!";
    } else {
		labelString = @"Sorry, you didn't beat the High Score.";
    }
    CCLOG(@"labelString: %@", labelString);
    
    CCLabelTTF *statusLabel = [CCLabelTTF labelWithString:labelString fontName:@"Marker Felt" fontSize:36.0f/scaleFactor];
    statusLabel.color = [CCColor colorWithRed:0.0f green:0.0f blue:0.0f];
    statusLabel.position = ccp(windowSize.width*0.50f, windowSize.height*0.80f);
    [self addChild:statusLabel];
    
    NSString *timeString = [NSString stringWithFormat:@"Time Bonus: %d", [[scores objectAtIndex:0] intValue]];
    NSString *streakString = [NSString stringWithFormat:@"Streak Bonus: %d", [[scores objectAtIndex:1] intValue]];
    NSString *incorrectString = [NSString stringWithFormat:@"Incorrect Penalty: %d", [[scores objectAtIndex:2] intValue]];
    NSString *totalString = [NSString stringWithFormat:@"Total Score: %d", [[scores objectAtIndex:3] intValue]];
    
    CCLabelTTF *timeScoreLabel = [CCLabelTTF labelWithString:timeString fontName:@"Marker Felt" fontSize:28.0f/scaleFactor];
    timeScoreLabel.color = [CCColor colorWithRed:0.0f green:0.0f blue:0.0f];
    timeScoreLabel.position = ccp(windowSize.width*0.50f, windowSize.height*0.70f);
    [self addChild:timeScoreLabel];
    
    CCLabelTTF *streakScoreLabel = [CCLabelTTF labelWithString:streakString fontName:@"Marker Felt" fontSize:28.0f/scaleFactor];
    streakScoreLabel.color = [CCColor colorWithRed:0.0f green:0.0f blue:0.0f];
    streakScoreLabel.position = ccp(windowSize.width*0.50f, windowSize.height*0.66f);
    [self addChild:streakScoreLabel];
    
    CCLabelTTF *incorrectLabel = [CCLabelTTF labelWithString:incorrectString fontName:@"Marker Felt" fontSize:28.0f/scaleFactor];
    incorrectLabel.color = [CCColor colorWithRed:0.0f green:0.0f blue:0.0f];
    incorrectLabel.position = ccp(windowSize.width*0.50f, windowSize.height*0.62f);
    [self addChild:incorrectLabel];
    
    CCLabelTTF *totalLabel = [CCLabelTTF labelWithString:totalString fontName:@"Marker Felt" fontSize:32.0f/scaleFactor];
    totalLabel.color = [CCColor colorWithRed:0.0f green:0.0f blue:0.0f];
    totalLabel.position = ccp(windowSize.width*0.50f, windowSize.height*0.55f);
    [self addChild:totalLabel];
    
    // Play Again Button
    
    // Return to Title Screen Button
    
    // Done
  	return self;
}
@end
