//
//  ZYWheelView.m
//  彩票转盘
//
//  Created by 王志盼 on 16/2/15.
//  Copyright © 2016年 王志盼. All rights reserved.
//

#import "ZYWheelView.h"

#define ZYImageW 40

#define ZYImageH 46

@interface ZYButton : UIButton

@end

@implementation ZYButton

/**
 *  重写此方法，截取button的点击
 *
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGFloat btnW = self.bounds.size.width;
    CGFloat btnH = self.bounds.size.height;
    
    CGFloat x = 0;
    CGFloat y = btnH / 2;
    CGFloat w = btnW;
    CGFloat h = y;
    CGRect rect = CGRectMake(x, y, w, h);
    if (CGRectContainsPoint(rect, point)) {
        return nil;
    }else{
        return [super hitTest:point withEvent:event];
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = (contentRect.size.width - ZYImageW ) * 0.5;
    CGFloat imageY = 18;
    return CGRectMake(imageX, imageY, ZYImageW, ZYImageH);
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

@end

@interface ZYWheelView ()
@property (weak, nonatomic) IBOutlet UIImageView *wheelView;

@property (nonatomic, weak) UIButton *lastSelectedBtn;

@property (nonatomic, strong) CADisplayLink *timer;
@end

@implementation ZYWheelView

+ (instancetype)wheelView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZYWheelView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    self.wheelView.userInteractionEnabled = YES;
    CGFloat angle = 2 * M_PI / 12.0;
    
    UIImage *normalImage = [UIImage imageNamed:@"LuckyAstrology"];
    UIImage *selectedImage = [UIImage imageNamed:@"LuckyAstrologyPressed"];
    
    for (int bi = 0; bi < 12; bi++) {
        ZYButton *btn = [[ZYButton alloc] init];
        [btn setBackgroundImage:[UIImage imageNamed:@"LuckyRototeSelected"] forState:UIControlStateSelected];
        
//        切割图片,将切割好的图片设置到按钮上
        // CGImage中rect是当做像素来使用
        // UIKit 中是点坐标系
        // 坐标系的特点:如果在非retain屏上 1个点等于1个像素
        //   在retain屏上1个点等于2个像素
        CGFloat imageH = ZYImageH * [UIScreen mainScreen].scale;
        CGFloat imageW = ZYImageW * [UIScreen mainScreen].scale;
        CGFloat imageY = 0;
        CGFloat imageX = bi * imageW;
        CGRect rect = CGRectMake(imageX, imageY, imageW, imageH);
        
        CGImageRef normalRef = CGImageCreateWithImageInRect(normalImage.CGImage, rect);
        CGImageRef selectedRef = CGImageCreateWithImageInRect(selectedImage.CGImage, rect);
        
        [btn setImage:[UIImage imageWithCGImage:normalRef] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageWithCGImage:selectedRef] forState:UIControlStateSelected];
        
        btn.bounds = CGRectMake(0, 0, 58, 143);
        
        btn.layer.anchorPoint = CGPointMake(0.5, 1);
        
        btn.layer.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        
        btn.transform = CGAffineTransformMakeRotation(angle * bi);
        
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.wheelView addSubview:btn];
    }
    [self startRotating];
}

- (void)startRotating
{

    if (self.timer) return;
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTimer)];
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopRotating
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)clickBtn:(UIButton *)btn
{
    self.lastSelectedBtn.selected = NO;
    btn.selected = YES;
    self.lastSelectedBtn = btn;
}

- (IBAction)clickCenterBtn:(id)sender {
    
    self.userInteractionEnabled = NO;
    [self stopRotating];
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    basicAnimation.toValue = @(M_PI * 2 * 5);
    basicAnimation.duration = 2;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    basicAnimation.removedOnCompletion = NO;
//    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.delegate = self;
    [self.wheelView.layer addAnimation:basicAnimation forKey:nil];
    
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.userInteractionEnabled = YES;
    
    // 根据选中的按钮获取旋转的度数,
    // 通过transform获取角度
    CGFloat angle = atan2(self.lastSelectedBtn.transform.b, self.lastSelectedBtn.transform.a);
    
    // 从实际上旋转转盘
    self.wheelView.transform = CGAffineTransformMakeRotation(-angle);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startRotating];
    });
    
}

- (void)updateTimer
{
    self.wheelView.transform = CGAffineTransformRotate(self.wheelView.transform, M_PI / 200);
}

- (void)dealloc
{
    [self stopRotating];
}

@end
