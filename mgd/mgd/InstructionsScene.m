//
//  InstructionsScene.m
//  mgd
//
//  Created by Nick Stelzer on 5/1/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import "InstructionsScene.h"
#import "cocos2d-ui.h"

@implementation InstructionsScene
{

}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Get Screen Size & Font Size
    CGSize windowSize = [[CCDirector sharedDirector] viewSize];
    float fontSize = windowSize.height / 32;
    
    // Set Background
    CCSprite *background = [CCSprite spriteWithImageNamed:@"background.png"];
    background.position = ccp(windowSize.width*0.5f, windowSize.height*0.5f);
	[self addChild:background];
    
    // Title Label
    CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"How To Play" fontName:@"Arial Narrow Bold" fontSize:fontSize*1.8];
    titleLabel.color = [CCColor colorWithUIColor:[UIColor blackColor]];
    titleLabel.position = ccp(windowSize.width*0.5f, windowSize.height*0.90f);
    [self addChild:titleLabel];
    
    // Instructions
    NSString *line1 = @"Pop the balloon that contains the";
    NSString *line2 = @"answer of the problem at the top";
    NSString *line3 = @"of the screen.";
    NSString *linx1 = @"You have 3 lifelines to help you out:";
    NSString *linx2 = @"Skip - Skip a tough problem until later.";
    NSString *linx3 = @"Freeze - Stops the timer until you answer right.";
    NSString *linx4 = @"50/50 - Narrows your choices down to 2.";
    NSString *line4 = @"The game ends once you have popped";
    NSString *line5 = @"all of the balloons.";
    NSString *line6 = @"Try your best to beat the fastest time!";
    NSString *instructions = [NSString stringWithFormat:@"%@\n%@\n%@\n\n%@\n%@\n%@\n%@\n\n%@\n%@\n\n%@", line1, line2, line3, linx1, linx2, linx3, linx4, line4, line5, line6];
    
    CCLabelTTF *instLabel = [CCLabelTTF labelWithString:instructions fontName:@"Arial Narrow" fontSize:fontSize];
    instLabel.color = [CCColor colorWithUIColor:[UIColor blackColor]];
    instLabel.horizontalAlignment = CCTextAlignmentCenter;
    instLabel.position = ccp(windowSize.width*0.5f, windowSize.height*0.62f);
    [self addChild:instLabel];
    
    // Back Button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Back ]" fontName:@"Arial Narrow" fontSize:fontSize*1.2];
    backButton.color = [CCColor colorWithUIColor:[UIColor blackColor]];
    backButton.position = ccp(windowSize.width*0.5f, windowSize.height*0.14f);
    [backButton setTarget:self selector:@selector(onBackClick)];
    [self addChild:backButton];
    
    // Done
    return self;
}

- (void)onBackClick
{
    [[CCDirector sharedDirector] popScene];
}
@end
