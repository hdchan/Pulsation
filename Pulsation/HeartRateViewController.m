//
//  HeartRateViewController.m
//  Pulsation
//
//  Created by Henry Chan on 7/17/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "HeartRateViewController.h"

@interface HeartRateViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *pulsatingImage;
@property (nonatomic) BOOL animating;


@end

@implementation HeartRateViewController

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    self.pulsatingImage = [self circleByApplyingAlpha:1.0];
    
    
    self.imageView.image = self.pulsatingImage;

    
}

- (void)pulsateWithTimeInterval:(NSTimer *)timer {
    
    if (self.animating) {
        return;
    }
    
    self.animating = YES;
    
    
    double delayInSeconds = 0;
    
    double delayAdd = timer.timeInterval/60;
    
    int count = 0;
    
    for (int i = 30; i > 0; i--) {
        
        delayInSeconds += + delayAdd;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((delayInSeconds) * NSEC_PER_SEC));
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                self.imageView.image = [self circleByApplyingAlpha: i / 30.0];
            }];
        });
        count ++;
        
    }
    
    for (int i = 0; i <= 29; i++) {
        
        delayInSeconds += delayAdd;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((delayInSeconds) * NSEC_PER_SEC));
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                self.imageView.image = [self circleByApplyingAlpha: i / 30.0];
                
                if (i == 29) {
                    
                    self.animating = NO;
                    
                }
            }];
        });
        count++ ;
        
    }
    
    NSLog(@"%u",count);
    
    
}

- (IBAction)startTapped:(id)sender {
    
    [NSTimer scheduledTimerWithTimeInterval:0.48 target:self selector:@selector(pulsateWithTimeInterval:) userInfo:nil repeats:YES];
    
//    [self pulsate];
}


- (IBAction)stopTapped:(id)sender {
    
    
}

- (UIImage *)circleByApplyingAlpha:(CGFloat) alpha {
    
    UIImage *opaqueCircle = nil;
    
    UIColor *color = [UIColor redColor];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100.f, 100.f), NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGRect rect = CGRectMake(0, 0, 100, 100);
    CGContextSetAlpha(ctx, alpha);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillEllipseInRect(ctx, rect);
    
    CGContextRestoreGState(ctx);
    opaqueCircle = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return opaqueCircle;
}

@end
