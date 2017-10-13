//
//  IVBezierPathRenderer.h
//  Pods
//
//  Created by Ivan Li on 16/6/2016.
//
//

@import MapKit;

@interface IVBezierPathRenderer : MKOverlayPathRenderer

@property (retain, nonatomic) NSNumber *tension;
@property (retain, nonatomic) UIColor *borderColor;
// Colors for gradient
@property (retain, nonatomic) NSArray *trackColors;
@property (nonatomic, assign) CGFloat borderMultiplier;

-(instancetype)initWithOverlay:(id<MKOverlay>)overlay tension:(NSNumber*)tension;

@end
