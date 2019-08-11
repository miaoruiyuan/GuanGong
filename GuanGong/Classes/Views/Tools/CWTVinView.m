//
//  CWTVinView.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/20.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTVinView.h"
#import "TTTAttributedLabel.h"
#import "CWTPasteButton.h"

@interface CWTVinView ()

@property(nonatomic,strong)UITextField *textField;

@property(nonatomic,strong)NSMutableArray<CWTPasteButton *> *buttons;

@property(nonatomic,strong)NSMutableArray *valueArray;

@property(nonatomic,assign)NSInteger nextIndex;

@property(nonatomic,copy)NSString *vin;

@end

@implementation CWTVinView
{
    UIButton *_selectedButton;
}

- (void)clearInputText
{
    self.textField.text = @"";
    self.vin = @"";

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:17];
    for (NSInteger i = 0; i < 17; i ++) {
        [array addObject:[NSNull null]];
    }
    [self.valueArray removeAllObjects];
    [self.valueArray addObjectsFromArray:array];
    
    UIImage *normalImage = [UIImage imageWithColor:[UIColor whiteColor]];
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
        button.selected = NO;
    }];
    
    self.buttons[0].selected = YES;
}

- (id)init{
    if (self = [super init]) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    [self removeAllSubviews];
    _valueArray = [NSMutableArray arrayWithCapacity:17];
    for (NSInteger i = 0; i < 17; i ++) {
        [_valueArray addObject:[NSNull null]];
    }
    _buttons = [NSMutableArray arrayWithCapacity:17];
    
    @weakify(self);
    [[[RACObserve(self, vin) skip:1] deliverOnMainThread]subscribeNext:^(NSString *x) {
        @strongify(self);
        if (self.inputValueBlock) {
            self.inputValueBlock(x);
        }
    }];
    
    UIImage *normalImage = [UIImage imageWithColor:[UIColor whiteColor]];
    UIImage *yellowImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"ffa9a9"]]; //红
    UIImage *blueImage =  [UIImage imageWithColor:[UIColor colorWithHexString:@"9ebef2"]]; //蓝

    UIButton *lastButton = nil;
    for (int i = 0 ; i < _valueArray.count; i ++) {
        CWTPasteButton *button = [CWTPasteButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:normalImage forState:UIControlStateHighlighted];
        
        [button setBackgroundImage:yellowImage forState:UIControlStateSelected];
        [button setBackgroundImage:yellowImage forState:UIControlStateSelected | UIControlStateHighlighted];
        button.layer.borderColor = [UIColor colorWithHexString:@"d7d7d7"].CGColor;
        button.layer.borderWidth = 1;
        button.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
        [self addSubview:button];
        
    
        if (![_valueArray[i] isEqual:[NSNull null]]) {
            button.selected = YES;
            button.highlighted =  NO;
            [button setTitle:_valueArray[i] forState:UIControlStateNormal];
        }
        
        if (i == 0) {
            button.selected = YES;
        }
    
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *x) {
            [self.textField becomeFirstResponder];
            
            if ([[x titleForState:UIControlStateNormal] length] > 0){
                _selectedButton.selected = NO;
                x.selected = YES;
                _selectedButton = x;
                _nextIndex = x.tag;
            }
        }];
        
        [button setPasteVinBlock:^(NSString *vin){
            self.vin = [vin uppercaseString];
            if (self.inputValueBlock) {
                self.inputValueBlock(self.vin);
            }
            [self reloadButtons];
        }];

        [self.buttons addObject:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            if (i < 8) {
                make.top.equalTo(self.mas_top).offset(30);
                
                if (lastButton) {
                    if (i == 3) {
                        make.left.equalTo(lastButton.mas_right).offset(5);
                    }else{
                        make.left.equalTo(lastButton.mas_right).offset(2);
                    }
                    
                    make.width.equalTo(lastButton.mas_width);
                    
                }else{
                    make.left.equalTo(self.mas_left).offset(35);
                }
                
                if (i == 7) {
                    make.right.equalTo(self.mas_right).offset(-35);
                }
                
            }else{
                
                if (i == 8) {
                    make.top.equalTo(lastButton.mas_bottom).offset(5);
                    make.left.equalTo(self.mas_left).offset(17);
                }else{
                    make.top.equalTo(lastButton.mas_top);
                    
                    if (i == 11) {
                        make.left.equalTo(lastButton.mas_right).offset(5);
                    }else{
                        make.left.equalTo(lastButton.mas_right).offset(2);
                    }
                }
                
                make.width.equalTo(lastButton.mas_width);
                
                if (i == 16) {
                    make.right.equalTo(self.mas_right).offset(-17).priority(700);
                }
            }
        }];
        lastButton = button;
    }
    
    [self addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-18);
        make.centerX.equalTo(self.mas_centerX).offset(-38);
        make.height.mas_equalTo(16);
    }];
    
    [self addSubview:self.buyBtn];
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countLabel.mas_right).offset(2);
        make.bottom.equalTo(self.mas_bottom).offset(-11);
        make.size.mas_equalTo(CGSizeMake(82, 30));
    }];
    
    [self.textField setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *field, NSRange range, NSString *value) {
        @strongify(self);
    
        if (value.length > 0) {
            value = [value uppercaseString];
            if (_nextIndex < self.vin.length) {
                [self.valueArray replaceObjectAtIndex:self.nextIndex withObject:value];
                range.location = self.vin.length - 1;
            }else{
                if (self.vin.length == 17) {
                    return NO;
                }
                [self.valueArray replaceObjectAtIndex:self.vin.length withObject:value];
                range.location = self.vin.length;
            }
            _nextIndex = range.location + 1;
            
        }else{
            if (range.location > 16) {
                range.location = 16;
            }
            [self.valueArray replaceObjectAtIndex:range.location withObject:[NSNull null]];
            _nextIndex = range.location;
        }
        
        DLog(@"valueArray :%@",self.valueArray);
        
        NSMutableString *mString = [NSMutableString stringWithCapacity:17];
        [self.valueArray enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CWTPasteButton *button = self.buttons[idx];
            if (![obj isEqual:[NSNull null]]) {
                [button setTitle:obj forState:UIControlStateNormal];
                [button setBackgroundImage:blueImage forState:UIControlStateNormal];
                button.selected = NO;
                [mString appendString:obj];
            }else{
                [button setTitle:@"" forState:UIControlStateNormal];
                [button setBackgroundImage:normalImage forState:UIControlStateNormal];
                if (idx == _nextIndex) {
                    button.selected = YES;
                }else{
                    button.selected = NO;
                }
            }
        }];
        
        self.vin = mString;
        
        DLog(@"CWTVinView_Input_VIN:%@",mString);
    
        return YES;
    }];
}

- (void)setCount:(NSInteger)count{
    _count = count;
    
    [self.countLabel setText:[NSString stringWithFormat:@"剩余查询 %zd次",_count] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSRange markRange = [[mutableAttributedString string] rangeOfString:@"剩余查询" options:NSCaseInsensitiveSearch];
        [mutableAttributedString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13 weight:UIFontWeightThin],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"9d9d9d"]} range:markRange];
        
        return mutableAttributedString;
    }];
}
//0123456789abcdefg

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.keyboardType = UIKeyboardTypeASCIICapable;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.spellCheckingType = UITextSpellCheckingTypeNo;
        
        [self addSubview:_textField];
    }
    return _textField;
}

- (TTTAttributedLabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _countLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        _countLabel.textColor = [UIColor colorWithHexString:@"9d9d9d"];
        _countLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        _countLabel.text = @"剩余查询0次";
    }
    return _countLabel;
}

- (UIButton *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyBtn setTitle:@"购买次数 >>" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor colorWithHexString:@"508cee"] forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _buyBtn;
}

- (BOOL)becomeFirstResponder{
    return [self.textField becomeFirstResponder];
}

- (void)reloadButtons{
    
    self.textField.text = self.vin;
    NSArray *array = [self.vin convertToArray];
    [self.valueArray removeAllObjects];
    [self.valueArray addObjectsFromArray:array];
    
    UIImage *bgImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"9ebef2"]];
    [self.valueArray enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CWTPasteButton *button = self.buttons[idx];
        [button setTitle:obj forState:UIControlStateNormal];
        [button setBackgroundImage:bgImage forState:UIControlStateNormal];
        button.selected = NO;
    }];
    
    [self.textField becomeFirstResponder];
}

@end
