//
//  JellyButton.h
//  JellyButton
//
//  Created by JT Ma on 20/04/2018.
//  Copyright © 2018 JT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JellyElasticOrientationVertical                = 1 << 0,
    JellyElasticOrientationHorizontal              = 1 << 1,
    JellyElasticOrientationVerticalAndHorizontal   = (JellyElasticOrientationVertical | JellyElasticOrientationHorizontal),
} JellyElasticOrientation;

@interface JellyLayer : CALayer

@property (nonatomic) float elasticHorizontal;
@property (nonatomic) float elasticVertical;

- (void)elasticRotate:(float)angle dynamics:(float)persent;
- (void)elasticOrientation:(JellyElasticOrientation)orientation;
- (void)elasticOrientation:(JellyElasticOrientation)orientation rotation:(float)angle;

@end

@interface JellyButton : UIButton

@property (nonatomic, getter=isElasticEnable) BOOL elasticEnable;
@property (nonatomic) JellyElasticOrientation elasticOrientation;

@end
