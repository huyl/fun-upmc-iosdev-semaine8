//
//  View.h
//  owned-RouleTaBille
//
//  Created by Huy on 6/25/14.
//  Copyright (c) 2014 huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewModel.h"

@interface View : UIView

@property (nonatomic) CGPoint billeLocation;

@property (nonatomic, weak) UILabel *positionXLabel;
@property (nonatomic, weak) UILabel *positionYLabel;
@property (nonatomic, weak) UILabel *deltaXLabel;
@property (nonatomic, weak) UILabel *deltaYLabel;
@property (nonatomic, weak) UILabel *accelerationXLabel;
@property (nonatomic, weak) UILabel *accelerationYLabel;
@property (nonatomic, weak) UILabel *edgeXLabel;
@property (nonatomic, weak) UILabel *edgeYLabel;

- (id)initWithFrame:(CGRect)frame andViewModel:(ViewModel *)viewModel;

@end
