//
//  Achievements.h
//  mgd
//
//  Created by Nick Stelzer on 5/30/14.
//  Copyright (c) 2014 Nick Stelzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Achievements : NSObject

- (void)updateTenCorrectStreakAchievement;
- (void)updateThreeIncorrectStreakAchievement;
- (void)updateNoLifelinesAchievement;
- (void)updateTotalGamesAchievement:(int)totalGames;

@end
