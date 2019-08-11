//
//  GGInputViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/28.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGInputViewController.h"

@interface GGInputViewController ()
@property(nonatomic,strong)GGFormItem *item;
@property(nonatomic,strong)GGPersonalInput *content;

@property(nonatomic,strong)UIView *inputBg;
@property(nonatomic,strong)UITextField *inputTextField;
@property(nonatomic,strong)UILabel *tipLabel;

@end

@implementation GGInputViewController

- (instancetype)initWithItem:(GGFormItem *)item{
    if (self = [super init]) {
        self.item = item;
        self.content = item.pageContent;
    }
    return self;
}

- (void)setupView{
    self.view.backgroundColor = tableBgColor;
    self.navigationItem.title = self.item.title;
    
    self.navigationItem.rightBarButtonItem.tintColor = themeColor;
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"完成" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self.view endEditing:YES];
        //去首尾空格
        NSString *inputText = [self.inputTextField.text removeSpaces];
        
        if (![inputText checkStringWithRegular:self.content.regular]) {
            [MBProgressHUD showError:self.content.tip toView:self.view];
            return ;
        }
        
        self.item.obj = inputText;
        if (self.popHandler) {
            self.popHandler(self.item);
        }
        [self pop];
    }];
    
    
    
    [self.view addSubview:self.inputBg];
    [self.inputBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(-1);
        make.right.equalTo(self.view.mas_right).offset(1);
        make.height.mas_equalTo(@45);
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(60);
    }];
    
    
    self.inputTextField.keyboardType = self.content.keyBoardType;
    self.inputTextField.autocapitalizationType = self.content.autoCapitalType;
    [self.inputBg addSubview:self.inputTextField];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputBg.mas_left).offset(20);
        make.right.equalTo(self.inputBg.mas_right).offset(-20);
        make.top.equalTo(self.inputBg.mas_top);
        make.height.equalTo(self.inputBg.mas_height);
    }];
    
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.inputBg.mas_bottom).offset(10);
    }];
    
    
    
    self.inputTextField.text = self.item.obj;
    self.inputTextField.placeholder = self.content.placeholder;
    self.tipLabel.text = self.content.footerTip;
    
    
    RAC(self.navigationItem.rightBarButtonItem,enabled) = [RACSignal combineLatest:@[self.inputTextField.rac_textSignal]
                                                                            reduce:^id(NSString *text){
                                                                                return @(text.length > 0);
                                                                            }];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.inputTextField becomeFirstResponder];
}



-(UIView *)inputBg{
    if (!_inputBg) {
        _inputBg = [[UIView alloc] init];
        _inputBg.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _inputBg;
}
-(UITextField *)inputTextField{
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.font = [UIFont systemFontOfSize:15];
        _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _inputTextField;
}
-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}


@end
