//
//  ChartView.m
//  StockIndexTable
//
//  Created by Techmaster on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChartLayer.h"
@interface ChartLayer()
{
    NSArray *_data;
}
@end
@implementation ChartLayer
@synthesize lineColor = _lineColor;

-(void) initWithData: (NSArray *)data andFrame: (CGRect)frame
{
   _lineColor = [UIColor redColor];
   _data = data;
   self.frame = frame;
    [self setNeedsDisplay];
}

-(void)drawInContext:(CGContextRef)ctx {	
	// Create the path
	CGSize size = self.bounds.size;
    float step_width = size.width / ([_data count] -1);
    float x = 0;
	CGContextBeginPath(ctx);
    for (int step=0; step < [_data count]; step++) {
        if (step==0) {
            CGContextMoveToPoint(ctx, x, [[_data objectAtIndex:step] floatValue]);
        } else {
            CGContextAddLineToPoint(ctx, x, [[_data objectAtIndex:step] floatValue]);
        }
        x+= step_width;
        
    }
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextDrawPath(ctx, kCGPathStroke);
    /*
    
    CGContextAddLineToPoint(ctx, size.width, 0);
    
    CGContextAddLineToPoint(ctx, size.width, size.height);
    
	CGContextClosePath(ctx);*/
	
	// Color it
	//CGContextSetFillColorWithColor(ctx, self.lineColor.CGColor);
	
}

@end
