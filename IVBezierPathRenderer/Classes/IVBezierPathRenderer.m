//
//  IVBezierPathRenderer.m
//  Pods
//
//  Created by Ivan Li on 16/6/2016.
//
//
#import "UIBezierPath+GuidedPath.h"
#import "IVBezierPathRenderer.h"

@implementation IVBezierPathRenderer

-(instancetype)initWithOverlay:(id<MKOverlay>)overlay{
    return [self initWithOverlay:overlay tension:@4];
}

-(instancetype)initWithOverlay:(id<MKOverlay>)overlay tension:(NSNumber *)tension{
    if(self = [super initWithOverlay:overlay]){
        self.tension = tension;
        self.borderMultiplier = 0;
        self.borderColor = [UIColor blackColor];
    }
    return self;
}

-(void)createPath{
    if (![self.overlay respondsToSelector:@selector(pointCount)]) {
        NSAssert(NO, @"The overlay is not a MKMultiPoint");
    }
    
    MKMultiPoint *multiPoint = self.overlay;
    NSMutableArray *cgPoints = [NSMutableArray array];
    
    for (NSInteger i = 0; i<multiPoint.pointCount; i++) {
        [cgPoints addObject:[NSValue valueWithCGPoint:[self pointForMapPoint:multiPoint.points[i]]]];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (NSValue *cgPointValue in cgPoints) {
        if ([cgPoints indexOfObject:cgPointValue] == 0) {
            [path moveToPoint:cgPointValue.CGPointValue];
        }else{
            [path addLineToPoint:cgPointValue.CGPointValue];
        }
    }
    
    self.path = self.tension.floatValue==0?[path bezierFlat].CGPath:[path bezierCardinalWithTension:self.tension.floatValue].CGPath;
}

- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)context
{
    CGFloat baseWidth = self.lineWidth;
    
    // draw the border. it's slightly wider than the specified line width.
    if (self.borderMultiplier > 0) {
        [self drawLine:self.borderColor.CGColor
                 width:baseWidth * self.borderMultiplier
           allowDashes:NO
          forZoomScale:zoomScale
             inContext:context];
    }
    
    // draw the actual line.
    [self drawLine:self.strokeColor.CGColor
             width:baseWidth
       allowDashes:YES
      forZoomScale:zoomScale
         inContext:context];
    
}

- (void)drawLine:(CGColorRef)color
           width:(CGFloat)width
     allowDashes:(BOOL)allowDashes
    forZoomScale:(MKZoomScale)zoomScale
       inContext:(CGContextRef)context
{
    CGContextAddPath(context, self.path);
    
    // use the defaults which takes care of the dash pattern
    // and other things
    if (allowDashes) {
        [self applyStrokePropertiesToContext:context atZoomScale:zoomScale];
    } else {
        // some setting we still want to apply
        CGContextSetLineCap(context, self.lineCap);
        CGContextSetLineJoin(context, self.lineJoin);
        CGContextSetMiterLimit(context, self.miterLimit);
    }
    
    // now set the colour and width
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, width / zoomScale);
    
    CGContextStrokePath(context);
}

@end
