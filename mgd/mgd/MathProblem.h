//
//  MathProblem.h
//  mgd
//
//  Created by Nick Stelzer on 4/10/14.
//  Copyright (c) 2014 Nick Stelzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathProblem : NSObject
{

}

@property (strong, nonatomic) NSString *problemString;
@property (nonatomic) int solution;
@property (nonatomic) BOOL answered;
@property (nonatomic) int index;

-(id)initAddition;

@end
