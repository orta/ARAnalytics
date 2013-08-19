//
//  HockeyAppProvider.h
//  
//
//  Created by Daniel Haight on 16/08/2013.
//
//

#import "ARAnalyticalProvider.h"

@interface HockeyAppProvider : ARAnalyticalProvider
-(id)initWithBetaIdentifier:(NSString *)betaIdentifier liveIdentifier:(NSString *)liveIdentfier;
@end
