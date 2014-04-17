//
//  PostGameNode.m
//  mgd
//
//  Created by Nick Stelzer on 4/16/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import "PostGameNode.h"


@implementation PostGameNode

- (id)init
{
	// This should never be called
	return [self initWithWin:YES scaleFactor:1.0f];
}

-(id)initWithWin:(BOOL)win scaleFactor:(float)scaleFactor
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
  	
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
    [self addChild:statusLabel];
    
    // Play Again Button
    
    // Return to Title Screen Button
    
    // Done
  	return self;
}
@end
