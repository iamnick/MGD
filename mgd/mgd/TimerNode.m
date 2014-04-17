//
//  TimerNode.m
//  mgd
//
//  Created by Nick Stelzer on 4/16/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import "TimerNode.h"


@implementation TimerNode
{
	CCLabelTTF *_timerLabel;
    CCTime _totalTime;
    float _elapsedTime;
    float _currentTime;
    float _textScaleFactor;
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
	
    // Initialize Variables
    _textScaleFactor = [[CCDirector sharedDirector] contentScaleFactor];
	_elapsedTime = 0.0f;
    
    // Create "Time" Label
    
    // Create Actual Timer Label
    _timerLabel = [CCLabelTTF labelWithString:@"0.00" fontName:@"Marker Felt" fontSize:56.0f/_textScaleFactor];
    _timerLabel.color = [CCColor colorWithRed:0.0f green:0.0f blue:0.0f];
	[self addChild:_timerLabel];
    
    // Update Timer
    [self schedule:@selector(updateLabel:) interval:0.01f];
    
    // Done
    return self;
}

- (void)updateLabel:(CCTime)delta
{
	_totalTime += delta;
    _currentTime = (float)_totalTime;
    if (_elapsedTime < _currentTime)
    {
    	_elapsedTime = _currentTime;
        [_timerLabel setString:[NSString stringWithFormat:@"%.2f", _elapsedTime]];
    }
}

- (float)getTime
{
	CCLOG(@"_elapsedTime: %f", _elapsedTime);
	float time = [_timerLabel.string floatValue];
    return time;
}

@end
