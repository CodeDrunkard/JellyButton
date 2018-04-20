CATransform

struct CGAffineTransform
{
    CGFloat a, b, c, d;
    CGFloat tx, ty;
};
             |a, b, 0|
[X, Y, 1] |c, d, 0| = [aX+cY+tx, bX+dY+ty, 1];
             |tx,ty,1|

1.平移
             |1, 0, 0|
[X, Y, 1] |0, 1, 0| = [X+tx, Y+ty, 1];
             |tx,ty,1|

2.缩放
             |a, 0, 0|
[X, Y, 1] |0, d, 0| = [aX, dY, 1];
             |0, 0, 1|

3.旋转
e=pi a=cosɵ，b=sinɵ，c=-sinɵ，d=cosɵ
             |a, b, 0|
[X, Y, 1] |c, d, 0| = [Xcosɵ-Ysine, Xsine+Ycose, 1];
             |0, 0, 1|

struct CATransform3D
{
    CGFloat m11, m12, m13, m14;
    CGFloat m21, m22, m23, m24;
    CGFloat m31, m32, m33, m34;
    CGFloat m41, m42, m43, m44;
};

| m11(x缩放), m12(y切变), m13(旋转),  m14() |

| m21(x切变), m22(y缩放), m23(),         m24() |

| m31(旋转),  m32(),           m33(),         m34(透视效果，要操作的这个对象要有旋转的角度，否则没有效果。正直/负值都有意义) |

| m41(x平移), m42(y平移), m43(z平移), m44() |

*/
