//
//  GGVinRecognitionViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGVinRecognitionViewController.h"
#import <ReactiveObjC/RACDelegateProxy.h>

@interface GGVinRecognitionViewController ()
@property(nonatomic,strong)GGFormItem *item;
@property(nonatomic,strong)GGPersonalInput *content;

@property(nonatomic,strong)UIView *inputBg;
@property(nonatomic,strong)UITextField *inputTextField;
@property(nonatomic,strong)UILabel *tipLabel;
@property(nonatomic,strong)UIButton *cameraButton;

@end

@implementation GGVinRecognitionViewController

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
        make.top.mas_equalTo(self.view.mas_top).offset(90);
    }];
    
    [self.inputBg addSubview:self.cameraButton];
    [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputBg.mas_right).offset(-10);
        make.centerY.equalTo(self.inputBg);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.inputBg addSubview:self.inputTextField];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputBg.mas_left).offset(20);
        make.right.equalTo(self.cameraButton.mas_left).offset(-12);
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
        
    RAC(self.navigationItem.rightBarButtonItem,enabled) = [[RACObserve(self.inputTextField, text)merge:self.inputTextField.rac_textSignal]map:^id(NSString *value) {
        return @(value.length > 0);
    }];
    
    //拍照按钮
    [[self.cameraButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {

    }];
    
    
}

- (void)bindViewModel{
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
        _inputTextField.keyboardType = self.content.keyBoardType;
        _inputTextField.autocapitalizationType = self.content.autoCapitalType;
        [_inputTextField becomeFirstResponder];

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

- (UIButton *)cameraButton{
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setImage:[UIImage imageNamed:@"vin_reco"] forState:UIControlStateNormal];
    }
    return _cameraButton;
}


@end
