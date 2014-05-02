//
//  MathProblem.m
//  mgd
//
//  Created by Nick Stelzer on 4/10/14.
//  Copyright (c) 2014 Nick Stelzer. All rights reserved.
//

#import "MathProblem.h"

@implementation MathProblem

- (id)initAddition
{
	self = [super init];
    if (self) {
    	// Generate Problem
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

- (id)initSubtraction
{
	self = [super init];
    if (self) {
    	// Generate Problem
        int a = arc4random_uniform(9);
        int b = arc4random_uniform(a);
        int s = a-b;
        
        // Create Problem String
        NSString *problemString = [[NSString alloc] initWithFormat:@"%d - %d", a, b];
        
        // Set Properties
        [self setProblemString:problemString];
        [self setSolution:s];
        [self setAnswered:NO];
    }
    return (self);
}

- (id)initMultiplication
{
	self = [super init];
    if (self) {
    	// Generate Problem
        int a = arc4random_uniform(4);
        int b = arc4random_uniform(3) + 1;
        int s = a*b;
        
        // Create Problem String
        NSString *problemString = [[NSString alloc] initWithFormat:@"%d x %d", a, b];
        
        // Set Properties
    	[self setProblemString:problemString];
        [self setSolution:s];
        [self setAnswered:NO];
    }
    return (self);
}

- (id)initDivision
{
	self = [super init];
    if (self) {
    	// Generate Problem
        int a = arc4random_uniform(4);
        int b = arc4random_uniform(3) + 1;
        int s = a*b;
        
        // Create Problem String
        NSString *problemString = [[NSString alloc] initWithFormat:@"%d / %d", s, a];
        
        // Set Properties
        [self setProblemString:problemString];
        [self setSolution:s];
        [self setAnswered:NO];
    }
	return (self);
}

@end
