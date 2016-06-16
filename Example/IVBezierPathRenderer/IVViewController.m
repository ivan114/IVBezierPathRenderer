//
//  IVViewController.m
//  IVBezierPathRenderer
//
//  Created by Ivan on 06/16/2016.
//  Copyright (c) 2016 Ivan. All rights reserved.
//

#import "IVViewController.h"
@import IVBezierPathRenderer;
@import MapKit;

@interface IVViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray<NSValue*> *mapPointArray;

@end

@implementation IVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.mapPointArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPointBarButtonAction:(UIBarButtonItem *)sender {
    CLLocationCoordinate2D currentPoint = self.mapView.centerCoordinate;
    [self.mapPointArray addObject:[NSValue valueWithMKCoordinate:currentPoint]];
    [self updateMapView];
}

- (IBAction)clearBarButtonAction:(UIBarButtonItem *)sender {
    [self.mapPointArray removeAllObjects];
    [self updateMapView];
}

-(void)updateMapView{
    [self.mapView removeOverlays:self.mapView.overlays];
    
    CLLocationCoordinate2D coordArray[[self.mapPointArray count]];
    for (NSInteger i=0; i<[self.mapPointArray count]; i++) {
        CLLocationCoordinate2D coord = self.mapPointArray[i].MKCoordinateValue;
        coordArray[i] = coord;
    }
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordArray count:[self.mapPointArray count]];
    [self.mapView addOverlay:polyline];
}

-(MKOverlayRenderer*)mapView:(MKMapView*)mapView rendererForOverlay:(id<MKOverlay>) overlay{
    if([overlay isKindOfClass:[MKPolyline class]]){
        IVBezierPathRenderer *renderer = [[IVBezierPathRenderer alloc] initWithOverlay:overlay];
        renderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.4f];
        renderer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
        renderer.lineWidth = 10;
        renderer.borderMultiplier = 1.5;
        return renderer;
    }
    return nil;
}

@end
