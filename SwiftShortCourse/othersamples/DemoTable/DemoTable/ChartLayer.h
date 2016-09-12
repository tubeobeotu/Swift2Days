//
//  ChartView.h
//  StockIndexTable
//
//  Created by Techmaster on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface ChartLayer : CALayer
@property (nonatomic, strong) UIColor* lineColor;

-(void) initWithData: (NSArray *)data andFrame: (CGRect)frame;
@end
