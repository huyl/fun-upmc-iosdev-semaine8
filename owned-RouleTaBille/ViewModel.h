//
//  BIlleViewModel.h
//  owned-RouleTaBille
//
//  Created by Huy on 6/25/14.
//  Copyright (c) 2014 huy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
	double x;
	double y;
} Velocity;


@interface ViewModel : NSObject

@property (nonatomic, weak) UIColor *backgroundColor;
@property (nonatomic) CGSize billeSize;

@property (nonatomic) CGPoint location;
@property (nonatomic) Velocity velocity;
@property (nonatomic) CMAcceleration gravity;

@property (nonatomic) BOOL billeIsAtVerticalEdge;
@property (nonatomic) BOOL billeIsAtHorizontalEdge;

- (instancetype)initWithBounds:(CGRect)bounds;
- (void)startUpdatingWithInterval:(NSTimeInterval)interval;

- (void)rotateColors;

@end
