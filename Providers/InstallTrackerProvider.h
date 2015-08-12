#import "ARAnalyticalProvider.h"

@interface InstallTrackerProvider : ARAnalyticalProvider

/*!
 * If the logger is enabled you will recieve diagnostic messages about tracker
 * workflow into xCode terminal and into asl. By default logger is disabled.
 *
 * \param flag The bool value which disables or enables logs
 */
+ (void)setLoggerEnable:(BOOL)flag;

@end
