//
//  JellyButton.m
//  JellyButton
//
//  Created by JT Ma on 20/04/2018.
//  Copyright © 2018 JT. All rights reserved.
//

#import "JellyButton.h"

const float kJellyElasticAnimationDuration = 0.25;
const float kJellyElasticAnimationMaxDynamics = 0.25;
const float kJellyTouchInsetOffset = 50;

NS_INLINE CATransform3D CATransform3DMakeRotationScale(CGFloat angle, CGFloat x, CGFloat y, CGFloat z) {
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, angle, 0, 0, 1);
    transform = CATransform3DScale(transform, x, y, z);
    transform = CATransform3DRotate(transform, -angle, 0, 0, 1);
    return transform;
}

@interface JellyLayer ()

@end

@implementation JellyLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.elasticVertical = 0.2;
        self.elasticHorizontal = 0.2;
    }
    return self;
}

- (void)elasticRotate:(float)angle dynamics:(float)dynamics {
    float x = cosf(angle) * dynamics / 2, y = sinf(angle) * dynamics / 2;
    self.anchorPoint = CGPointMake(0.5 - x, 0.5 - y);
    self.transform = CATransform3DMakeRotationScale(angle, 1+dynamics, 1, 1);
}

- (void)elasticOrientation:(JellyElasticOrientation)orientation {
    [self elasticOrientation:orientation rotation:0.0];
}

- (void)elasticOrientation:(JellyElasticOrientation)orientation rotation:(float)angle {
    float v = 1, h = 1;
    if (orientation & JellyElasticOrientationVertical) v += self.elasticVertical;
    if (orientation & JellyElasticOrientationHorizontal) h += self.elasticHorizontal;
    
    CABasicAnimation *animationAnchorPoint = [CABasicAnimation animationWithKeyPath:@"anchorPoint"];
    animationAnchorPoint.fromValue = [NSValue valueWithCGPoint:self.anchorPoint];
    animationAnchorPoint.toValue = [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
    animationAnchorPoint.duration = kJellyElasticAnimationDuration / 4;
    self.anchorPoint = CGPointMake(0.5, 0.5);
    
    CAKeyframeAnimation *animationTransform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animationTransform.values = [NSArray arrayWithObjects:
                        [NSValue valueWithCATransform3D:self.transform],
                        [NSValue valueWithCATransform3D:CATransform3DMakeRotationScale(angle, h, 2-h, 1)],
                        [NSValue valueWithCATransform3D:CATransform3DMakeRotationScale(angle, 1-(h-1)*0.5, 1+(h-1)*0.5, 1)],
                        [NSValue valueWithCATransform3D:CATransform3DMakeRotationScale(angle, 1+(h-1)*0.25, 1-(h-1)*0.25, 1)],
                        [NSValue valueWithCATransform3D:CATransform3DMakeRotationScale(angle, 1, 1, 1)], nil];
    animationTransform.keyTimes = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0],
                          [NSNumber numberWithFloat:0.3],
                          [NSNumber numberWithFloat:0.6],
                          [NSNumber numberWithFloat:0.9],
                          [NSNumber numberWithFloat:1], nil];
    self.transform = CATransform3DIdentity;
    animationTransform.timingFunctions = [NSArray arrayWithObjects:
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], nil];
    animationTransform.duration = kJellyElasticAnimationDuration;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:animationTransform, animationAnchorPoint, nil];
    group.duration = kJellyElasticAnimationDuration;
    [self addAnimation:group forKey:@""];
}

@end

@interface JellyButton ()

@property (nonatomic, strong, readonly) JellyLayer *jellyLayer;

@end

@implementation JellyButton {
    BOOL _touchInSide;
}

+ (Class)layerClass {
    return [JellyLayer class];
}

- (JellyLayer *)jellyLayer {
    return (JellyLayer *)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.elasticOrientation = JellyElasticOrientationVerticalAndHorizontal;
}

#pragma mark - Touch Event

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    _touchInSide = YES;
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (_touchInSide) {
        CGPoint point = [touch locationInView:self];
        CGRect rect = self.bounds;
        if (CGRectContainsPoint(CGRectInset(rect, -kJellyTouchInsetOffset, -kJellyTouchInsetOffset), point)) {
            float y = point.y - rect.size.height / 2, x = point.x - rect.size.width / 2;
            float angle = atan2f(y, x);
            float length = sqrtf(x*x + y*y);
            float persent = length / rect.size.width * kJellyElasticAnimationMaxDynamics;
            [self.jellyLayer elasticRotate:angle dynamics:persent];
        } else {
            _touchInSide = NO;
            [self elasticWithTouchPoint:[touch locationInView:self]];
        }
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (_touchInSide) {
        _touchInSide = NO;
        [self elasticWithTouchPoint:[touch locationInView:self]];
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    if (_touchInSide) {
        _touchInSide = NO;
        [self.jellyLayer elasticOrientation:_elasticOrientation];
    }
}

- (void)elasticWithTouchPoint:(CGPoint)point {
    float angle = [self elasticRotationWithTouchPoint:point];
    [self.jellyLayer elasticOrientation:_elasticOrientation rotation:angle];
}

- (float)elasticRotationWithTouchPoint:(CGPoint)point {
    CGRect rect = self.bounds;
    float y = point.y - rect.size.height / 2, x = point.x - rect.size.width / 2;
    float angle = atan2f(y, x);
    return angle;
}

@end
