![IVBezierPathRenderer](http://cl.ly/gT4q/IVBezierPathRendererBanner.png)

[![CI Status](http://img.shields.io/travis/Ivan/IVBezierPathRenderer.svg?style=flat)](https://travis-ci.org/Ivan/IVBezierPathRenderer)
[![Version](https://img.shields.io/cocoapods/v/IVBezierPathRenderer.svg?style=flat)](http://cocoapods.org/pods/IVBezierPathRenderer)
[![License](https://img.shields.io/cocoapods/l/IVBezierPathRenderer.svg?style=flat)](http://cocoapods.org/pods/IVBezierPathRenderer)
[![Platform](https://img.shields.io/cocoapods/p/IVBezierPathRenderer.svg?style=flat)](http://cocoapods.org/pods/IVBezierPathRenderer)

##Introduction
  *MapKit* framework provide us useful classes for drawing simple path in *MKMapView*. 
  However, those lines draw with *MKPolylineRenderer* are too plat and unstylized, and most importantly, no bezier path, which is not sufficient for my map application usage. 
  Therefore, ***IVBezierPathRenderer*** is created for more natural map path drawing.

##Screenshots
![Screenshots](http://cl.ly/gTB7/IVBezierPathRendererScreenshots.png)
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

IVBezierPathRenderer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "IVBezierPathRenderer"
```

After installing the pod add the following import header to your source code

```objc
@import IVBezierPathRenderer;
```

##Usage
_IVBezierPathRenderer_ is easy to use. Just create your MKPolyline and MKPolylineRenderer as usual, then replace your _MKPolylineRenderer_ object with _IVBezierPathRenderer_ object. That is all need to be done.
###Swift:
```swift
func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
	if let overlay = overlay as? MKPolyline{
		let renderer = IVBezierPathRenderer(overlay:overlay)
		renderer.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
		renderer.lineWidth = 4
		//Optional Tension for curve, default: 4
	 	//renderer.tension = 2.5
		//Optional Border
		//renderer.borderColor = renderer.strokeColor
		//renderer.borderMultiplier = 1.5
		return renderer
	}
}
```
###Objective-C:
```objc
-(MKOverlayRenderer*)mapView:(MKMapView*)mapView rendererForOverlay:(id<MKOverlay>) overlay{
	 if([overlay isKindOfClass:[MKPolyline class]]){
	 	IVBezierPathRenderer *renderer = [[IVBezierPathRenderer alloc] initWithOverlay:overlay];
	 	renderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5f];
	 	renderer.lineWidth = 4;
	 	//Optional Tension for curve, default: 4
	 	//renderer.tension = 2.5;
	 	//Optional Border
		//renderer.borderColor = renderer.strokeColor;
		//renderer.borderMultiplier = 1.5;
	 	return renderer;
	 }
 }
```
## Author

Ivan Li, ivanlidev@icloud.com

##References

- ASPolylineView by nighthawk (https://github.com/nighthawk/ASPolylineView)
- Draw a Bezier Curve through a set of 2D Points in iOS (http://ymedialabs.github.io/blog/2015/05/12/draw-a-bezier-curve-through-a-set-of-2d-points-in-ios/)

## License

IVBezierPathRenderer is available under the MIT license. See the LICENSE file for more info.
