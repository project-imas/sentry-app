//
//  iMASFilterClass.h
//  sentry-app
//
//  Created by Ren, Alice on 8/15/14.
//  Copyright (c) 2014 MITRE Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iMASFilterClass : NSObject

- (id) init;
+ (id) alloc;
+ (NSMutableArray *)loadFilters;
+ (void)writeFilters:(NSArray *)filters;

@end
