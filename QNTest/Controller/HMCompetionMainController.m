

//
//  HMCompetionMainController.m
//  HuoMao
//
//  Created by 山神 on 2018/3/30.
//  Copyright © 2018年 火猫. All rights reserved.
//

#import "HMCompetionMainController.h"

#import "MXSegmentedPager.h"

#import "HMCompetionForecastController.h"
#import "HMCompetionScheduleController.h"
#import "Masonry.h"

#define JSScreenWidth [[UIScreen mainScreen] bounds].size.width
#define JSScreenHeight [[UIScreen mainScreen] bounds].size.height
@interface HMCompetionMainController ()<MXParallaxHeaderDelegate,MXSegmentedPagerDelegate,MXSegmentedPagerDataSource>

@property(nonatomic,strong) MXSegmentedPager *segmentedPager;  //分块控制器
@property(nonatomic,strong) HMCompetionScheduleController *scheduleVc;  //  赛程
@property(nonatomic,strong) HMCompetionForecastController *forecastVc;  // 赛事预测

@end

@implementation HMCompetionMainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _setupUI];
    self.view.backgroundColor =[UIColor redColor];
      self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.segmentedPager = [[MXSegmentedPager alloc] initWithFrame:CGRectMake(0, 0, JSScreenWidth , JSScreenHeight)];
}

#pragma mark UI
-(void)_setupUI
{
    // 头部
    self.segmentedPager = [[MXSegmentedPager alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.segmentedPager.parallaxHeader.view = nil; // 注意这里加载平行头部
    // MXParallaxHeaderModeCenter MXParallaxHeaderModeCenter MXParallaxHeaderModeTop  MXParallaxHeaderModeBottom四个，大家可以自己测试
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeFill; // 平行头部填充模式
    self.segmentedPager.parallaxHeader.height = 240; // 头部高度
    self.segmentedPager.parallaxHeader.minimumHeight = 64; // 头部最小高度
    
    // 选择栏控制器属性
    self.segmentedPager.segmentedControl.borderWidth = 1.0; // 边框宽度
    self.segmentedPager.segmentedControl.borderColor = [UIColor redColor]; // 边框颜色
    self.segmentedPager.segmentedControl.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44); // frame
    self.segmentedPager.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);// 间距
    self.segmentedPager.segmentedControl.selectionIndicatorHeight = 0;// 底部是否需要横条指示器，0的话就没有了，如图所示
    // 底部指示器的宽度是否根据内容
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    //HMSegmentedControlSelectionIndicatorLocationNone 不需要底部滑动指示器
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    self.segmentedPager.segmentedControl.verticalDividerEnabled = NO;// 不可以垂直滚动
    // fix的枚举说明宽度是适应屏幕的，不会根据字体   HMSegmentedControlSegmentWidthStyleDynamic则是字体多大就多宽
    self.segmentedPager.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    
    // 默认状态的字体
    self.segmentedPager.segmentedControl.titleTextAttributes =
    @{NSForegroundColorAttributeName : [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1],
      NSFontAttributeName : [UIFont systemFontOfSize:14]};
    // 选择状态下的字体
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes =
    @{NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0 green:174/255.0 blue:1 alpha:1],
      NSFontAttributeName : [UIFont systemFontOfSize:18]};
    self.segmentedPager.segmentedControlEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.segmentedPager.delegate = self;
    self.segmentedPager.dataSource = self;
    [self.view addSubview:self.segmentedPager];
    [self.segmentedPager mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(self.view.mas_top).with.offset(0);
         make.left.equalTo(self.view.mas_left);
         make.bottom.equalTo(self.view.mas_bottom);
         make.right.equalTo(self.view.mas_right);
         make.width.equalTo(self.view.mas_width);
     }];

}

#pragma -mark <MXSegmentedPagerDelegate>

- (CGFloat)heightForSegmentedControlInSegmentedPager:(MXSegmentedPager *)segmentedPager
{// 指示栏的高度
    return 44.0f;
}

#pragma -mark <MXSegmentedPagerDataSource>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager
{
    // 需要多少个界面
    return 2;
}
- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index
{
    // 指示栏的文字数组
    return [@[@"赛程",@"赛事预测"] objectAtIndex:index];
}

- (__kindof UIViewController *)segmentedPager:(MXSegmentedPager *)segmentedPager viewControllerForPageAtIndex:(NSInteger)index
{
    if (index == 0)
    {
        return self.scheduleVc;
    }
    else
    {
        return self.forecastVc;
    }
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager segueIdentifierForPageAtIndex:(NSInteger)index
{
    if (index == 0)
    {
        return @"赛程";
    }
    else
    {
        return @"赛事预测";
    }
}


- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index
{
    // 第一个是控制器的View 第二个是WebView  第三个是自定义的View 这个也是最关键的，通过懒加载把对应控制的初始化View加载到框架上面去
    return [@[self.scheduleVc.view, self.forecastVc.view] objectAtIndex:index];
}

#pragma mark 懒加载区域
-(HMCompetionScheduleController *)scheduleVc
{
    if (_scheduleVc == nil)
    {
        _scheduleVc = [[HMCompetionScheduleController alloc]init];
        _scheduleVc.view.frame = CGRectMake(0, 0, JSScreenWidth, JSScreenHeight);
    }
    return _scheduleVc;
}
-(HMCompetionForecastController *)forecastVc
{
    if (_forecastVc == nil)
    {
        _forecastVc =[[HMCompetionForecastController alloc]init];
        _scheduleVc.view.frame = CGRectMake(0, 0, JSScreenWidth, JSScreenHeight);
    }
    return _forecastVc;
}





















- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

@end
