//
//  Achievements.m
//  mgd
//
//  Created by Nick Stelzer on 5/30/14.
//  Copyright (c) 2014 Nick Stelzer. All rights reserved.
//

#import "Achievements.h"
#import <GameKit/GameKit.h>

@implementation Achievements

- (void)updateTenCorrectStreakAchievement
{
	GKAchievement *tenStreakAchievement = [[GKAchievement alloc] initWithIdentifier:@"Achievement_10CorrectStreak"];
    
    tenStreakAchievement.percentComplete = 100.0;
	[self reportAchievement:tenStreakAchievement];
}

- (void)updateThreeIncorrectStreakAchievement
{
	GKAchievement *threeIncorrectAchievement = [[GKAchievement alloc] initWithIdentifier:@"Achievement_3IncorrectStreak"];
    
    threeIncorrectAchievement.percentComplete = 100.0;
	[self reportAchievement:threeIncorrectAchievement];
}

- (void)updateNoLifelinesAchievement
{
	GKAchievement *noLifelineAchievement = [[GKAchievement alloc] initWithIdentifier:@"Achievement_NoLifelines"];
    
    noLifelineAchievement.percentComplete = 100.0;
   	[self reportAchievement:noLifelineAchievement];
}

- (void)updateTotalGamesAchievement:(int)totalGames
{
	GKAchievement *totalGamesAchievement = nil;
    NSString *identifier;
    float progress = 0.0;
    
	if (totalGames == 1) {
    	identifier = @"Achievement_1Game";
        progress = totalGames * 100 / 1;
    } else if (totalGames <= 10) {
    	identifier = @"Achievement_10Games";
        progress = totalGames * 100 / 10;
    } else if (totalGames <= 50) {
    	identifier = @"Achievement_50Games";
        progress = totalGames * 100 / 50;
    }
    NSLog(@"%d", totalGames);
    NSLog(@"%f", progress);
    
    totalGamesAchievement = [[GKAchievement alloc] initWithIdentifier:identifier];
    totalGamesAchievement.percentComplete = progress;
    
    [self reportAchievement:totalGamesAchievement];
}

// Private method to report an achievement
- (void)reportAchievement:(GKAchievement*)achievement {
	NSArray *array = @[achievement];
    [GKAchievement reportAchievements:array withCompletionHandler:^(NSError *error) {
    	if (error != nil) {
        	NSLog(@"%@", [error localizedDescription]);
        }
    }];
}
@end
