//
//  GGBusinessChartCell.m
//  GuanGong
//
//  Created by CodingTom on 2017/2/15.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGBusinessChartCell.h"
#import <PNChart/PNChart.h>


@interface GGBusinessChartCell()
{

}

@property (nonatomic,strong)UIView *lineChartContentView;
@property (nonatomic,strong)PNLineChart *lineChart;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UILabel *dateLabel;


@end

@implementation GGBusinessChartCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.bottomView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)showChartByModel:(NSObject *)model
{
    self.lineChart.showCoordinateAxis = YES;
    self.lineChart.yLabelFormat = @"%1.1f";
    self.lineChart.xLabelFont = [UIFont fontWithName:@"Helvetica-Light" size:8.0];
    self.lineChart.yLabelColor = [UIColor colorWithHexString:@"aebecc"];
    self.lineChart.xLabelColor = [UIColor colorWithHexString:@"aebecc"];
    
    // added an example to show how yGridLines can be enabled
    // the color is set to clearColor so that the demo remains the same
    self.lineChart.showGenYLabels = NO;
    self.lineChart.showYGridLines = YES;
    
    //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
    //Only if you needed
    self.lineChart.yFixedValueMax = 300.0;
    self.lineChart.yFixedValueMin = 0.0;
    
    [self.lineChart setXLabels:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
    [self.lineChart setYLabels:@[
                                 @"0",
                                 @"50",
                                 @"100",
                                 @"150",
                                 @"200",
                                 @"250",
                                 @"300",
                                 ]
     ];
    
    // Line Chart #1
    NSArray *data01Array = @[@15.1, @60.1, @110.4, @10.0, @186.2, @197.2, @276.2];
    data01Array = [[data01Array reverseObjectEnumerator] allObjects];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.dataTitle = @"Alpha";
    data01.color = [UIColor colorWithHexString:@"4D86C4"];
    data01.pointLabelColor = [UIColor colorWithHexString:@"4D86C4"];
    data01.showPointLabel = YES;
    data01.pointLabelFont = [UIFont systemFontOfSize:9.0];
    data01.itemCount = data01Array.count;
    data01.inflexionPointColor = [UIColor colorWithHexString:@"4D86C4"];
    data01.inflexionPointStyle = PNLineChartPointStyleCircle;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
//    // Line Chart #2
//    NSArray *data02Array = @[@0.0, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
//    PNLineChartData *data02 = [PNLineChartData new];
//    data02.dataTitle = @"Beta";
//    data02.pointLabelColor = [UIColor blackColor];
//    data02.color = PNTwitterColor;
//    data02.alpha = 0.5f;
//    data02.itemCount = data02Array.count;
//    data02.inflexionPointStyle = PNLineChartPointStyleCircle;
//    data02.getData = ^(NSUInteger index) {
//        CGFloat yValue = [data02Array[index] floatValue];
//        return [PNLineChartDataItem dataItemWithY:yValue];
//    };
    
    self.lineChart.chartData = @[data01];
    [self.lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
        obj.pointLabelColor = [UIColor blackColor];
    }];

    [self.lineChart strokeChart];;
}

- (UIView *)lineChartContentView
{
    if (!_lineChartContentView) {
        _lineChartContentView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH - 24, 172.0)];
        
        NSArray *items = @[@"月",@"日"];
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        segmentedControl.frame = CGRectMake(5, 8, 72, 21);
        
        segmentedControl.selectedSegmentIndex = 0;
        
        segmentedControl.tintColor = [UIColor colorWithHexString:@"4d86c4"];
        
        [_lineChartContentView addSubview:segmentedControl];
        _lineChartContentView.backgroundColor = [UIColor colorWithHexString:@"F9F9F9"];
        [self.contentView addSubview:_lineChartContentView];
    }
    return _lineChartContentView;
}

- (PNLineChart *)lineChart
{
    if (!_lineChart) {
        _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0,40, SCREEN_WIDTH - 24, 130.0)];
        _lineChart.backgroundColor = [UIColor colorWithHexString:@"F9F9F9"];
        [self.lineChartContentView addSubview:_lineChart];
    }
    return _lineChart;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 172, SCREEN_WIDTH, 40)];
        [self.contentView addSubview:_bottomView];
        [_bottomView addSubview:self.dateLabel];

        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, 0, 60, 40);
        
        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        [leftBtn setImage:[UIImage imageNamed:@"btn_left_chart_n"] forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"btn_left_chart_h"] forState:UIControlStateDisabled];

        [_bottomView addSubview:leftBtn];
        
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);

        [rightBtn setImage:[UIImage imageNamed:@"btn_right_chart_n"] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"btn_right_chart_h"] forState:UIControlStateDisabled];

        rightBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 60, 40);
        
        [_bottomView addSubview:rightBtn];

    }
    
    return _bottomView;
}


- (UILabel *)dateLabel
{
    if(!_dateLabel){
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 30)];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.text = @"2010";
        _dateLabel.backgroundColor = [UIColor whiteColor];
        _dateLabel.font = [UIFont systemFontOfSize:14];
        _dateLabel.textColor = [UIColor colorWithHexString:@"aebecc"];
    }
    return _dateLabel;
}
@end
