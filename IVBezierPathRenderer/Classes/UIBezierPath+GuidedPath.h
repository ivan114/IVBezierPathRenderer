//
//  UIBezierPath+GuidedPath.h
//  Pods
//
//  Created by Ivan Li on 16/6/2016.
//
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (GuidedPath)

-(UIBezierPath*)bezierCardinalWithTension:(CGFloat)tension;
-(UIBezierPath*)bezierFlat;

@end
