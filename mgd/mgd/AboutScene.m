//
//  AboutScene.m
//  mgd
//
//  Created by Nick Stelzer on 5/1/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import "AboutScene.h"
#import "cocos2d-ui.h"

@implementation AboutScene
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
    CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"About" fontName:@"Arial Narrow Bold" fontSize:fontSize*1.8];
    titleLabel.color = [CCColor colorWithUIColor:[UIColor blackColor]];
    titleLabel.position = ccp(windowSize.width*0.5f, windowSize.height*0.90f);
    [self addChild:titleLabel];
    
    // Credits
    NSString *line1 = @"App designed and developed by Nick Stelzer";
    NSString *line2 = @"iamnick@fullsail.edu";
    NSString *line3 = @"Boy Sprite courtesy of";
    NSString *line4 = @"Enoc Burgos - www.realillusion.com";
    NSString *line5 = @"Cloud Sprites courtesy of";
    NSString *line6 = @"GameArtForge - www.opengameart.org";
    NSString *credits = [NSString stringWithFormat:@"%@\n%@\n\n\n%@\n%@\n\n\n%@\n%@", line1, line2, line3, line4, line5, line6];
    
    CCLabelTTF *creditsLabel = [CCLabelTTF labelWithString:credits fontName:@"Arial Narrow" fontSize:fontSize];
    creditsLabel.color = [CCColor colorWithUIColor:[UIColor blackColor]];
    creditsLabel.horizontalAlignment = CCTextAlignmentCenter;
    creditsLabel.position = ccp(windowSize.width*0.5f, windowSize.height*0.62f);
    [self addChild:creditsLabel];
    
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
