//
//  MathProblem.m
//  mgd
//
//  Created by Nick Stelzer on 4/10/14.
//  Copyright (c) 2014 Nick Stelzer. All rights reserved.
//

#import "MathProblem.h"

@implementation MathProblem

- (id)init
{
	// Initialize an Addition problem if this is called (it shouldn't though)
	return [self initAddition];
}

- (id)initAddition
{
	self = [super init];
    if (self) {
    	// Choose 2 Small Random Integers
		int a = arc4random_uniform(9);
    	int b = arc4random_uniform(9);
        int s = a + b;
        
        // Create Problem String
        NSString *problemString = [[NSString alloc] initWithFormat:@"%d + %d", a, b];
        
        // Set Properties
        [self setProblemString:problemString];
    	[self setSolution:s];
    	[self setAnswered:NO];
    }
    return (self);
}

@end
