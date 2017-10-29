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

-(instancetype)initWithOverlay:(id<MKOverlay>)overlay
                gradientColors:(NSArray *)colors
                       tension:(NSNumber *)tension {
    if(self = [super initWithOverlay:overlay]){
        self.tension = tension;
        self.borderMultiplier = 0;
        self.borderColor = [UIColor blackColor];
        self.trackColors = colors;
    }
    return self;
}

-(void)createPath {
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
          inContext:(CGContextRef)context {
    CGFloat baseWidth = self.lineWidth;

    // draw the border. it's slightly wider than the specified line width.
    if (self.borderMultiplier > 0) {
        [self drawLine:self.borderColor.CGColor
                 width:(baseWidth * self.borderMultiplier) / zoomScale
           allowDashes:NO
          forZoomScale:zoomScale
             inContext:context];
    }

    // draw the actual line.
    if (self.trackColors != nil) {
        CFArrayRef colorsArray =  (__bridge CFArrayRef) [self colorsArray];
        [self drawGradientLine:colorsArray
                         width:baseWidth / zoomScale
                  forZoomScale:zoomScale
                     inContext:context];
    } else {
        [self drawLine:self.strokeColor.CGColor
                 width:baseWidth / zoomScale
           allowDashes:YES
          forZoomScale:zoomScale
             inContext:context];
    }
}

- (void)drawLine:(CGColorRef)color
           width:(CGFloat)width
     allowDashes:(BOOL)allowDashes
    forZoomScale:(MKZoomScale)zoomScale
       inContext:(CGContextRef)context {
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
    CGContextSetLineWidth(context, width);

    CGContextStrokePath(context);
}

- (void)drawGradientLine:(CFArrayRef)colorsArray
                   width:(CGFloat)width
            forZoomScale:(MKZoomScale)zoomScale
               inContext:(CGContextRef)context {
    // Draw Color space and prepare gradient for context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0, 0.5};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colorsArray, locations);
    CGContextSetLineWidth(context, width);
    CGContextSetLineJoin(context, self.lineJoin);
    CGContextSetLineCap(context, self.lineCap);
    CGContextSetMiterLimit(context, self.miterLimit);

    // Add path to context
    CGContextAddPath(context, self.path);
    CGContextSaveGState(context);
    CGContextReplacePathWithStrokedPath(context);
    CGContextClip(context);

    // Prepare gradient bounds
    CGRect boundingBox = CGPathGetBoundingBox(self.path);
    CGPoint gradientStart = boundingBox.origin;
    CGPoint gradientEnd = CGPointMake(CGRectGetMaxX(boundingBox), CGRectGetMaxY(boundingBox));

    // Draw gradient and clear memory
    CGContextDrawLinearGradient(context, gradient, gradientStart, gradientEnd, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (NSArray *)colorsArray {
    NSMutableArray *mutableColorsArray = [NSMutableArray new];

    for (UIColor *color in _trackColors) {
        [mutableColorsArray addObject:(__bridge id)color.CGColor];
    }
    return mutableColorsArray;
}

@end
