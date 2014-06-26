//
//  BIlleViewModel.m
//  owned-RouleTaBille
//
//  Created by Huy on 6/25/14.
//  Copyright (c) 2014 huy. All rights reserved.
//

#import "ViewModel.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewModel ()

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic) int colorIndex;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic) CGRect bounds;
@property (nonatomic) CGRect effectiveBounds;

@property (nonatomic, strong) AVAudioPlayer *player;

@end


@implementation ViewModel

- (instancetype)initWithBounds:(CGRect)bounds
{
    self = [super init];
    if (self) {
        _colors = @[[UIColor colorWithPatternImage:[UIImage imageNamed:@"jaune.jpg"]],
                    [UIColor colorWithPatternImage:[UIImage imageNamed:@"bleu.jpg"]],
                    [UIColor colorWithPatternImage:[UIImage imageNamed:@"rouge.jpg"]],
                    [UIColor colorWithPatternImage:[UIImage imageNamed:@"vert.jpg"]]];
        _colorIndex = 0;
        _backgroundColor = self.colors[self.colorIndex];
        
        _velocity.x = 0;
        _velocity.y = 0;
        
        _bounds = bounds;
        _effectiveBounds = bounds;
//        _billeIsAtEdge = NO;
        
        
        NSError *error;
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"son" ofType:@"mp3"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
        _player = player;
        
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC
{
    @weakify(self);
    [[RACObserve(self, billeIsAtVerticalEdge) distinctUntilChanged] subscribeNext:^(NSNumber *atEdge) {
        @strongify(self);
        if (atEdge.boolValue) {
            [self.player play];
        }
    }];
    [[RACObserve(self, billeIsAtHorizontalEdge) distinctUntilChanged] subscribeNext:^(NSNumber *atEdge) {
        @strongify(self);
        if (atEdge.boolValue) {
            [self.player play];
        }
    }];
}

- (void)rotateColors
{
    self.colorIndex = (self.colorIndex + 1) % [self.colors count];
    self.backgroundColor = self.colors[self.colorIndex];
}

- (void)startUpdatingWithInterval:(NSTimeInterval)interval
{
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                  target:self
                                                selector:@selector(updateBillePosition)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)setBilleSize:(CGSize)billeSize
{
    self.effectiveBounds = CGRectMake(self.bounds.origin.x,
                                      self.bounds.origin.y,
                                      self.bounds.size.width - billeSize.width,
                                      self.bounds.size.height - billeSize.height);
}

/*
- (BOOL)billeIsAtVerticalEdge
{
    CGFloat x = self.location.x;
    return x <= self.effectiveBounds.origin.x || x >= self.effectiveBounds.origin.x + self.effectiveBounds.size.width;
}

- (BOOL)billeIsAtHorizontalEdge
{
    CGFloat y = self.location.y;
    return y <= self.effectiveBounds.origin.y || y >= self.effectiveBounds.origin.y + self.effectiveBounds.size.height;
}
*/

- (void)updateBillePosition
{
    BOOL atHEdge = NO;
    BOOL atVEdge = NO;
    
    double vx, vy;
    
    vx = self.velocity.x + self.gravity.x;
    // Negative because velocity y-axis points down while gravity y-axis points up
    vy = self.velocity.y - self.gravity.y;
    
    CGFloat x, y;
    
    x = self.location.x + self.velocity.x / 500;
    y = self.location.y + self.velocity.y / 500;
    if (x <= self.effectiveBounds.origin.x) {
        x = self.effectiveBounds.origin.x;
        if (self.velocity.x < 0) {
            vx = 0;
        }
        atVEdge = YES;
    }
    if (x >= self.effectiveBounds.origin.x + self.effectiveBounds.size.width) {
        x = self.effectiveBounds.origin.x + self.effectiveBounds.size.width;
        if (self.velocity.x > 0) {
            vx = 0;
        }
        atVEdge = YES;
    }
    if (y <= self.effectiveBounds.origin.y) {
        y = self.effectiveBounds.origin.y;
        if (self.velocity.y < 0) {
            vy = 0;
        }
        atHEdge = YES;
    }
    if (y >= self.effectiveBounds.origin.y + self.effectiveBounds.size.height) {
        y = self.effectiveBounds.origin.y + self.effectiveBounds.size.height;
        if (self.velocity.y > 0) {
            vy = 0;
        }
        atHEdge = YES;
    }
    self.location = CGPointMake(x, y);
    
    Velocity v = { vx, vy };
    self.velocity = v;
    
    self.billeIsAtHorizontalEdge = atHEdge;
    self.billeIsAtVerticalEdge = atVEdge;
}

@end
