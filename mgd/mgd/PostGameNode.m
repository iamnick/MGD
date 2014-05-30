//
//  PostGameNode.m
//  mgd
//
//  Created by Nick Stelzer on 4/16/14.
//  Copyright 2014 Nick Stelzer. All rights reserved.
//

#import "PostGameNode.h"
#import "cocos2d-ui.h"
#import <GameKit/GameKit.h>
#import <Social/Social.h>
#import "Achievements.h"

@implementation PostGameNode
{
	NSString *_leaderboardIdentifer;
    CCLabelTTF *_highScoresTitleLabel;
    CCLabelTTF *_highScoresTableLabel;
    NSMutableString *_regHighScoreTable, *_noLLHighScoreTable;
    BOOL _showingAllHighScores;
    CCButton *_swapTableButton;
    Achievements *_achieveTracker;
}
-(id)initWithRoundScore:(NSNumber*)roundScore andRegHighScores:(NSMutableArray*)regHighScores andNoLLHighScores:(NSMutableArray*)noLLHighScores andAllHSIndex:(int)hsIndex andNoLLIndex:(int)nollIndex scaleFactor:(float)scaleFactor
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Achievements
    _achieveTracker = [[Achievements alloc] init];
    
    // Screen/Font Size
    CGSize windowSize = [[CCDirector sharedDirector] viewSize];
    
    // Show Highscores
    _showingAllHighScores = YES;
    _highScoresTitleLabel = [CCLabelTTF labelWithString:@"High Scores" fontName:@"Marker Felt" fontSize:32.0f/scaleFactor];
    _highScoresTitleLabel.color = [CCColor colorWithRed:0.0f green:0.0f blue:0.0f];
    _highScoresTitleLabel.position = ccp(windowSize.width*0.50f, windowSize.height*0.80f);
    [self addChild:_highScoresTitleLabel];
    
    // Create High Score Tables
    _regHighScoreTable = [[NSMutableString alloc] init];
    for (int i = 0; i < regHighScores.count; i++) {
    	if (hsIndex == i) {
        	[_regHighScoreTable appendString:@"Your Score: "];
        }
    	NSString *highScoreLine = [NSString stringWithFormat:@"%d\n", [[regHighScores objectAtIndex:i] intValue]];
    	[_regHighScoreTable appendString:highScoreLine];
    }
    // Show users score underneath table if it wasn't a high score
    if (hsIndex == -1) {
    	[_regHighScoreTable appendFormat:@"\n\nYour Score: %d", [roundScore intValue]];
    }
    
    _noLLHighScoreTable = [[NSMutableString alloc] init];
    for (int j = 0; j < noLLHighScores.count; j++) {
    	if (nollIndex == j) {
        	[_noLLHighScoreTable appendString:@"Your Score: "];
        }
        NSString *highScoreLine = [NSString stringWithFormat:@"%d\n", [[noLLHighScores objectAtIndex:j] intValue]];
        [_noLLHighScoreTable appendString:highScoreLine];
    }
    if (nollIndex == -1) {
    	[_noLLHighScoreTable appendFormat:@"\n\nYour Score: %d", [roundScore intValue]];
    }
    
    _highScoresTableLabel = [CCLabelTTF labelWithString:_regHighScoreTable fontName:@"Marker Felt" fontSize:32.0f/scaleFactor];
    _highScoresTableLabel.color = [CCColor colorWithRed:0.0f green:0.0f blue:0.0f];
    _highScoresTableLabel.position = ccp(windowSize.width*0.50f, windowSize.height*0.64f);
    _highScoresTableLabel.horizontalAlignment = CCTextAlignmentRight;
    _highScoresTableLabel.verticalAlignment  = CCVerticalTextAlignmentTop;
    [self addChild:_highScoresTableLabel];
    
    // Switch HighScores Table Button
    _swapTableButton = [CCButton buttonWithTitle:@"[ Show No-Lifeline High Scores ]" fontName:@"Arial Narrow" fontSize:24.0/scaleFactor];
    _swapTableButton.color = [CCColor colorWithUIColor:[UIColor blackColor]];
    _swapTableButton.position = ccp(windowSize.width*0.5f, windowSize.height*0.36f);
    [_swapTableButton setTarget:self selector:@selector(onSwapTableClick)];
    [self addChild:_swapTableButton];
    
	// GameCenter Highscores button (also report score if GC user is authenticated)
    CCButton *viewGCButton = [CCButton buttonWithTitle:@"[ View Game Center ]" fontName:@"Arial Narrow" fontSize:24.0/scaleFactor];
    viewGCButton.color = [CCColor colorWithUIColor:[UIColor blackColor]];
    viewGCButton.position = ccp(windowSize.width*0.5f, windowSize.height*0.32f);
    [viewGCButton setTarget:self selector:@selector(onViewGCClick)];
    [self addChild:viewGCButton];
    if ([GKLocalPlayer localPlayer].authenticated) {
    	[[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
        	if (error != nil) {
            	CCLOG(@"%@", [error localizedDescription]);
            } else {
            	_leaderboardIdentifer = leaderboardIdentifier;
                [self reportScore:roundScore];
            	viewGCButton.enabled = YES;
                viewGCButton.opacity = 1;
            }
        }];
    } else {
    	viewGCButton.enabled = NO;
        viewGCButton.opacity = .5;
    }
    
    // Share on Twitter
    CCButton *tweetScoreButton = [CCButton buttonWithTitle:@"[ Share on Twitter ]" fontName:@"Arial Narrow" fontSize:24.0/scaleFactor];
    tweetScoreButton.color = [CCColor colorWithUIColor:[UIColor blackColor]];
    tweetScoreButton.position = ccp(windowSize.width*0.5f, windowSize.height*0.28f);
    [tweetScoreButton setTarget:self selector:@selector(shareScoreOnTwitter)];
    [self addChild:tweetScoreButton];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
    	tweetScoreButton.enabled = YES;
        tweetScoreButton.opacity = 1;
    } else {
    	tweetScoreButton.enabled = NO;
        tweetScoreButton.opacity = .5;
    }
    
    // Done
  	return self;
}

- (void)reportScore:(NSNumber*)playerScore
{
	GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardIdentifer];
	score.value = [playerScore intValue];
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
    	if (error != nil) {
        	NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

- (void)onViewGCClick
{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;

	gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    gcViewController.leaderboardIdentifier = _leaderboardIdentifer;
    
    [[CCDirector sharedDirector] presentViewController:gcViewController animated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)shareScoreOnTwitter:(int)score
{
    SLComposeViewController *scoreTweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    NSString *initialText = [NSString stringWithFormat:@"Check out my latest score in Balloon Pop! %d!", score];
    [scoreTweet setInitialText:initialText];
    [[CCDirector sharedDirector] presentViewController:scoreTweet animated:YES completion:nil];
}

-(void)onSwapTableClick
{
	if (_showingAllHighScores) {
    	[_highScoresTitleLabel setString:@"No-Lifeline High Scores"];
    	[_highScoresTableLabel setString:_noLLHighScoreTable];
    	_swapTableButton.title = @"[ Show All High Scores ]";
    	_showingAllHighScores = NO;
    } else {
    	[_highScoresTitleLabel setString:@"All High Scores"];
    	[_highScoresTableLabel setString:_regHighScoreTable];
    	_swapTableButton.title = @"[ Show No-Lifeline High Scores ]";
    	_showingAllHighScores = YES;
    }
}
@end
