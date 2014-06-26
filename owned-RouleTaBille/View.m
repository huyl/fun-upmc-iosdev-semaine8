//
//  View.m
//  owned-RouleTaBille
//
//  Created by Huy on 6/25/14.
//  Copyright (c) 2014 huy. All rights reserved.
//

#import "View.h"
#import "Masonry.h"

@interface View ()

@property (nonatomic, weak) UIImageView *bille;
@property (nonatomic, weak) UILabel *xLabel;
@property (nonatomic, weak) UILabel *yLabel;
@property (nonatomic, weak) UILabel *positionLabel;
@property (nonatomic, weak) UILabel *deltaLabel;
@property (nonatomic, weak) UILabel *accelerationLabel;
@property (nonatomic, weak) UILabel *edgeLabel;

@property (nonatomic, weak) ViewModel *viewModel;

@end

@implementation View

- (id)initWithFrame:(CGRect)frame andViewModel:(ViewModel *)viewModel
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewModel = viewModel;
        
        self.backgroundColor = self.viewModel.backgroundColor;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bille.png"]];
        _bille = imageView;
        [self addSubview:imageView];
        
        // Let the view model know how much to offset the bounds so that the bille doesn't go out
        self.viewModel.billeSize = imageView.frame.size;
        
        UILabel *label;
        
        label = [[UILabel alloc] init];
        label.text = @"X";
        label.textAlignment = NSTextAlignmentCenter;
        _xLabel = label;
        [self addSubview:label];
        
        label = [[UILabel alloc] init];
        label.text = @"Y";
        label.textAlignment = NSTextAlignmentCenter;
        _yLabel = label;
        [self addSubview:label];
        
        label = [[UILabel alloc] init];
        label.text = @"Position";
        label.textAlignment = NSTextAlignmentRight;
        _positionLabel = label;
        [self addSubview:label];
        
        label = [[UILabel alloc] init];
        _positionXLabel = label;
        [self addSubview:label];
        label = [[UILabel alloc] init];
        _positionYLabel = label;
        [self addSubview:label];
        
        label = [[UILabel alloc] init];
        _deltaLabel = label;
        label.text = @"Vélocité";
        [self addSubview:label];
        
        label = [[UILabel alloc] init];
        _deltaXLabel = label;
        [self addSubview:label];
        label = [[UILabel alloc] init];
        _deltaYLabel = label;
        [self addSubview:label];
        
        label = [[UILabel alloc] init];
        _accelerationLabel = label;
        label.text = @"Gravité";
        [self addSubview:label];
        
        label = [[UILabel alloc] init];
        _accelerationXLabel = label;
        [self addSubview:label];
        label = [[UILabel alloc] init];
        _accelerationYLabel = label;
        [self addSubview:label];
        
        label = [[UILabel alloc] init];
        _edgeLabel = label;
        label.text = @"Bord";
        [self addSubview:label];
        
        label = [[UILabel alloc] init];
        _edgeXLabel = label;
        [self addSubview:label];
        label = [[UILabel alloc] init];
        _edgeYLabel = label;
        [self addSubview:label];
        
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Constraints

- (void)setupConstraints
{
    UIView *superview = self;
    
    // Config
    UIOffset internal = UIOffsetMake(15, 15);
    CGFloat columnWidth = 60;
    
    [self.xLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview).with.offset(100);
        make.centerX.equalTo(superview.mas_centerX).with.offset(20);
    }];
    [self.yLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xLabel);
        make.centerX.equalTo(self.xLabel.mas_centerX).with.offset(columnWidth);
    }];
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xLabel.mas_bottom).with.offset(internal.vertical);
        make.right.equalTo(self.xLabel.mas_centerX).with.offset(-columnWidth);
    }];
    [self.positionXLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.positionLabel);
        make.centerX.equalTo(self.xLabel);
    }];
    [self.positionYLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.positionLabel);
        make.centerX.equalTo(self.yLabel);
    }];
    [self.deltaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.positionLabel.mas_bottom).with.offset(internal.vertical);
        make.right.equalTo(self.positionLabel);
    }];
    [self.deltaXLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deltaLabel);
        make.centerX.equalTo(self.xLabel);
    }];
    [self.deltaYLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deltaLabel);
        make.centerX.equalTo(self.yLabel);
    }];
    [self.accelerationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deltaLabel.mas_bottom).with.offset(internal.vertical);
        make.right.equalTo(self.positionLabel);
    }];
    [self.accelerationXLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accelerationLabel);
        make.centerX.equalTo(self.xLabel);
    }];
    [self.accelerationYLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accelerationLabel);
        make.centerX.equalTo(self.yLabel);
    }];
    [self.edgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accelerationLabel.mas_bottom).with.offset(internal.vertical);
        make.right.equalTo(self.positionLabel);
    }];
    [self.edgeXLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.edgeLabel);
        make.centerX.equalTo(self.xLabel);
    }];
    [self.edgeYLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.edgeLabel);
        make.centerX.equalTo(self.yLabel);
    }];
}


- (void)setBilleLocation:(CGPoint)point
{
    self.bille.frame = CGRectMake(point.x,
                                  point.y,
                                  self.bille.frame.size.width,
                                  self.bille.frame.size.height);
}


@end
