//
//  ViewController.m
//  PinchZoom-UIImage
//
//  Created by Jeffrey Murphy on 5/20/13.
//  Copyright (c) 2013 Nickel City Software LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (retain, strong) IBOutlet UIImageView *imageView;
@property (retain, strong) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSLog(@"viewForZoomingInScrollView");
    return self.imageView;
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
    CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    return frameToCenter;
}

// http://stackoverflow.com/questions/638299/uiscrollview-with-centered-uiimageview-like-photos-app
- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    
    CGSize screenSize = [[self view] bounds].size;
    float initialZoom = 1.0f;
    
    if (self.scrollView.zoomScale <= initialZoom +0.01) //This resolves a problem with the code not working correctly when zooming all the way out.
    {
        self.imageView.frame = [[self view] bounds];
        [self.scrollView setZoomScale:self.scrollView.zoomScale +0.01];
    }
    
    UIImage *temporaryImage = self.imageView.image;
    
    if (self.scrollView.zoomScale > initialZoom)
    {
        if (CGImageGetWidth(temporaryImage.CGImage) > CGImageGetHeight(temporaryImage.CGImage)) //If the image is wider than tall, do the following...
        {
            if (screenSize.height >= CGImageGetHeight(temporaryImage.CGImage) * [self.scrollView zoomScale]) //If the height of the screen is greater than the zoomed height of the image do the following...
            {
                self.imageView.frame = CGRectMake(0, 0, 320*(self.scrollView.zoomScale), 368);
            }
            if (screenSize.height < CGImageGetHeight(temporaryImage.CGImage) * [self.scrollView zoomScale]) //If the height of the screen is less than the zoomed height of the image do the following...
            {
                self.imageView.frame = CGRectMake(0, 0, 320*(self.scrollView.zoomScale), CGImageGetHeight(temporaryImage.CGImage) * [self.scrollView zoomScale]);
            }
        }
        if (CGImageGetWidth(temporaryImage.CGImage) < CGImageGetHeight(temporaryImage.CGImage)) //If the image is taller than wide, do the following...
        {
            CGFloat portraitHeight;
            if (CGImageGetHeight(temporaryImage.CGImage) * [self.scrollView zoomScale] < 368)
            { portraitHeight = 368;}
            else {portraitHeight = CGImageGetHeight(temporaryImage.CGImage) * [self.scrollView zoomScale];}
            
            if (screenSize.width >= CGImageGetWidth(temporaryImage.CGImage) * [self.scrollView zoomScale]) //If the width of the screen is greater than the zoomed width of the image do the following...
            {
                self.imageView.frame = CGRectMake(0, 0, 320, portraitHeight);
            }
            if (screenSize.width < CGImageGetWidth (temporaryImage.CGImage) * [self.scrollView zoomScale]) //If the width of the screen is less than the zoomed width of the image do the following...
            {
                self.imageView.frame = CGRectMake(0, 0, CGImageGetWidth(temporaryImage.CGImage) * [self.scrollView zoomScale], portraitHeight);
            }
        }
        [self.scrollView setZoomScale:self.scrollView.zoomScale -0.01];
    }
}

-(void)scrollViewDidZoom1:(UIScrollView *)pScrollView
{
    NSLog(@"scrollViewDidZoom %f", self.scrollView.zoomScale);
    //self.imageView.frame = [self centeredFrameForScrollView:self.scrollView andUIView:self.imageView];



    CGRect innerFrame = self.imageView.frame;
    CGRect scrollerBounds = pScrollView.bounds;
    
    if ( ( innerFrame.size.width < scrollerBounds.size.width ) || ( innerFrame.size.height < scrollerBounds.size.height ) )
    {
        CGFloat tempx = self.imageView.center.x - ( scrollerBounds.size.width / 2 );
        CGFloat tempy = self.imageView.center.y - ( scrollerBounds.size.height / 2 );
        CGPoint myScrollViewOffset = CGPointMake( tempx, tempy);
        
        pScrollView.contentOffset = myScrollViewOffset;
        
    }
    
    UIEdgeInsets anEdgeInset = { 0, 0, 0, 0};
    if ( scrollerBounds.size.width > innerFrame.size.width )
    {
        anEdgeInset.left = (scrollerBounds.size.width - innerFrame.size.width) / 2;
        anEdgeInset.right = -anEdgeInset.left;  // I don't know why this needs to be negative, but that's what works
    }
    if ( scrollerBounds.size.height > innerFrame.size.height )
    {
        anEdgeInset.top = (scrollerBounds.size.height - innerFrame.size.height) / 2;
        anEdgeInset.bottom = -anEdgeInset.top;  // I don't know why this needs to be negative, but that's what works
    }
    pScrollView.contentInset = anEdgeInset;

}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
    //self.scrollView.contentSize = self.imageView.image.size;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
