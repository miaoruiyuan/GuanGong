//
//  GGPasscodeView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/27.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGPasscodeView.h"

#define Space 5
#define LineWidth (self.frame.size.width - lineNum * 2 * Space)/lineNum
#define LineHeight 2

//下标线距离底部高度
#define LineBottomHeight 5

//密码风格 圆点半径
#define RADIUS 5

@interface GGPasscodeView (){
    NSMutableArray *textArray;
    //线的条数
    NSInteger lineNum;
    
    UIColor *linecolor;
    UIColor *textcolor;
    UIFont *textFont;
    //观察者
    NSObject *observer;
    
}
@property(nonatomic,strong)UITextField *textField;

@end

@implementation GGPasscodeView

- (instancetype)initWithFrame:(CGRect)frame
                          num:(NSInteger)num
                    lineColor:(UIColor *)lColor
                     textFont:(CGFloat)font {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        textArray = [NSMutableArray arrayWithCapacity:num];
        
        lineNum = num;
        //数字样式是的颜色和线条颜色相同
        linecolor = textcolor = lColor;
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = lColor.CGColor;
        
        textFont = [UIFont boldSystemFontOfSize:font];
        
        //设置的字体高度小于self的高
        NSAssert(textFont.lineHeight < self.frame.size.height, @"设置的字体高度应该小于self的高");
        
        //单击手势
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginEdit)];
        [self addGestureRecognizer:tapGes];
    }
    
    return self;
}


- (void)setHasSpaceLine:(BOOL)hasSpaceLine {
    _hasSpaceLine = hasSpaceLine;
    if (hasSpaceLine) {
        [self addSpaceLine];
    }
    
}

//添加分割线
- (void)addSpaceLine {
    for (NSInteger i = 0; i < lineNum - 1; i ++) {
        CAShapeLayer *line = [CAShapeLayer layer];
        line.fillColor = linecolor.CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(self.frame.size.width/lineNum * (i + 1), 1, .5, self.frame.size.height - 1)];
        line.path = path.CGPath;
        line.hidden = NO;
        [self.layer addSublayer:line];
    }
}


#pragma mark - 添加通知
- (void)addNotification {
    //修复双击造成的bug
    if (observer) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    observer = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSInteger length = _textField.text.length;
        if (length == lineNum && self.EndEditBlcok) {
            self.EndEditBlcok(_textField.text,self);
            [self endEdit];
        }
        if (length > lineNum) {
            _textField.text = [_textField.text substringToIndex:lineNum];
            [self endEdit];
        }
        
        //改变数组，存储需要画的字符
        //通过判断textfield的长度和数组中的长度比较，选择删除还是添加
        if (length<=lineNum) {
            if (length > textArray.count) {
                [textArray addObject:[_textField.text substringWithRange:NSMakeRange(length - 1, 1)]];
            } else {
                [textArray removeLastObject];
            }
            //标记为需要重绘
            [self setNeedsDisplay];
        }
    
    }];
}


//键盘弹出
- (void)beginEdit {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.hidden = YES;
        [self addSubview:_textField];
    }
    [self addNotification];
    [self.textField becomeFirstResponder];
    
}

- (void)endEdit {
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
    [self.textField resignFirstResponder];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code
    switch (_codeType) {
        case CodeViewTypeCustom:{
            //画字
            //字的起点
            CGContextRef context = UIGraphicsGetCurrentContext();
            for (NSInteger i = 0; i < textArray.count; i ++) {
                NSString *num = textArray[i];
                CGFloat wordWidth = [num stringSizeWithFont:textFont Size:CGSizeMake(MAXFLOAT, textFont.lineHeight)].width;
                //起点
                CGFloat startX = self.frame.size.width/lineNum * i + (self.frame.size.width/lineNum - wordWidth)/2;
                
                [num drawInRect:CGRectMake(startX, (self.frame.size.height - textFont.lineHeight - LineBottomHeight - LineHeight)/2, wordWidth,  textFont.lineHeight + 5) withAttributes:@{NSFontAttributeName:textFont,NSForegroundColorAttributeName:textcolor}];
            }
            CGContextDrawPath(context, kCGPathFill);
        }
            break;
        case CodeViewTypeSecret:{
            //画圆
            CGContextRef context = UIGraphicsGetCurrentContext();
            for (NSInteger i = 0; i < textArray.count; i ++) {
                //圆点
                CGFloat pointX = self.frame.size.width/lineNum/2 * (2 * i + 1);
                CGFloat pointY = self.frame.size.height/2;
                CGContextAddArc(context, pointX, pointY, RADIUS, 0, 2*M_PI, 0);//添加一个圆
                CGContextDrawPath(context, kCGPathFill);//绘制填充
            }
            CGContextDrawPath(context, kCGPathFill);
            
        }
            break;
        default:
            break;
    }
    
}


@end
