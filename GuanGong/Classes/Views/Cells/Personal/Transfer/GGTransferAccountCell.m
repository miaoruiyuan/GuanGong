//
//  GGTransferAccountCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/3.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTransferAccountCell.h"

@interface GGTransferAccountCell()


@property (nonatomic,strong)UILabel *titleLabel;

@end

NSString * const kCellIdentifierTransferAccount = @"kGGTransferAccountCell";

@implementation GGTransferAccountCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, 80, 20)];
        _titleLabel.text = @"转账金额";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = textLightColor;
        [self.contentView addSubview:_titleLabel];
        
        
        UILabel *rmbLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom + 8, 30, 44)];
        rmbLabel.text = @"¥";
        rmbLabel.font = [UIFont systemFontOfSize:34];
        rmbLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:rmbLabel];
        
        _amountField = ({
            UITextField *field  = [[UITextField alloc]initWithFrame:CGRectMake(rmbLabel.right + 2, rmbLabel.top, kScreenWidth - 56, rmbLabel.height)];
            field.textColor = [UIColor blackColor];
            field.font = rmbLabel.font;
            field.placeholder = @"0.00";
            field.clearButtonMode = UITextFieldViewModeWhileEditing;
            field.keyboardType = UIKeyboardTypeDecimalPad;
            [self.contentView addSubview:field];
            field;
        });
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(rmbLabel.left, _amountField.bottom + 10, kScreenWidth - rmbLabel.origin.x, .7)];
        line.backgroundColor = sectionColor;
        [self.contentView addSubview:line];
        
        
        _remarkField = ({
            UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(line.left, line.bottom + 10 , line.width - 12, 20)];
            field.textColor = textNormalColor;
            field.font = [UIFont systemFontOfSize:16];
            field.placeholder = @"备注(15字以内)";
            field.clearButtonMode = UITextFieldViewModeWhileEditing;
            [self.contentView addSubview:field];
            
//            field.bk_shouldChangeCharactersInRangeWithReplacementStringBlock = ^(UITextField *textField, NSRange range, NSString *string){
//                
//                if (range.location >= 10) {
//                    return NO;
//                }
//                return YES;
//            };
            
            
            field;
        });
        
    }
    return self;
}

- (void)updataUIByType:(BOOL)isTransfer
{
    if (isTransfer) {
        self.titleLabel.text = @"转账金额";
    } else {
        self.titleLabel.text = @"担保金额";
    }
}

@end
