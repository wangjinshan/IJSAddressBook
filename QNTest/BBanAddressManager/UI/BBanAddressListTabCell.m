
//
//  BBanAddressListTabCell.m
//  QNTest
//
//  Created by 山神 on 2018/5/16.
//  Copyright © 2018年 山神. All rights reserved.
//

#import "BBanAddressListTabCell.h"
#import "BBanAddressPerson.h"
#import "BBanCommunicationManager.h"
#import "BBanFoundation.h"

@interface BBanAddressListTabCell()

@property (strong, nonatomic)  UIImageView *iconImageV; //头像
@property (strong, nonatomic)  UILabel *nameLabel; // 名字
@property (strong, nonatomic)  UILabel *phoneNumLabel; // 电话
@property(nonatomic,strong) UIButton *sendMessagerButton;  // 发送短信
@property(nonatomic,strong) UIButton *callButton;  // 打电话
@end

@implementation BBanAddressListTabCell
/// 设置数据
-(void)setModel:(BBanAddressPerson *)model
{
    _model =model;
    self.iconImageV.image = model.image ? model.image : [UIImage imageNamed:@"hand portrait"];
    self.nameLabel.text = model.fullName;
    BBanPhone *phoneModel = model.phones.firstObject;
    self.phoneNumLabel.text = phoneModel.phone;
}
#pragma mark -  点击事件
/// 打电话行为
-(void)callPersonAction:(UIButton *)button
{
    if (self.phoneNumLabel.text == nil)
    {
        [self showAlertViewWithTitle:@"没有有效的电话号码"];
        return;
    }
    [BBanCommunicationManager callSomeBodyWithPhoneNumber:self.phoneNumLabel.text];
}
/// 发短信
-(void)sendMessagerAction:(UIButton *)button
{
    if (self.phoneNumLabel.text == nil)
    {
        [self showAlertViewWithTitle:@"没有有效的电话号码"];
        return;
    }
    [BBanCommunicationManager sendMessageForSomeBodyWithPhoneNumbers:@[self.phoneNumLabel.text] content:@"奇乐直播,欢乐无穷,快快加入" delegateVc:[BBanFViewController currentViewController]];
}

/// UI 布局
-(void)layoutSubviews
{
    [super layoutSubviews];
    /// 头像
    self.iconImageV.frame = CGRectMake(10, 10, CGRectGetHeight(self.frame) - 20, CGRectGetHeight(self.frame) - 20);
    self.iconImageV.layer.cornerRadius = (CGRectGetHeight(self.frame) - 20) *0.5f;
    self.iconImageV.layer.masksToBounds = YES;
    /// 名字
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageV.frame) + 10, 10, CGRectGetWidth(self.frame) - 130 - CGRectGetMaxX(self.iconImageV.frame), 40);
    /// 电话
    self.phoneNumLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageV.frame) + 10, CGRectGetMaxY(self.iconImageV.frame) - 30, 150, 30);
    /// 打电话
    self.callButton.frame = CGRectMake(CGRectGetWidth(self.frame) - 120, CGRectGetHeight(self.frame) * 0.5f - 20, 50, 40);
    /// 发短信
    self.sendMessagerButton.frame = CGRectMake(CGRectGetMaxX(self.callButton.frame) + 5, CGRectGetMinY(self.callButton.frame), 50, 40);
}
#pragma mark -  懒加载
/// 头像
-(UIImageView *)iconImageV
{
    if (!_iconImageV)
    {
        _iconImageV =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, CGRectGetHeight(self.frame) - 20, CGRectGetHeight(self.frame) - 20)];
        _iconImageV.layer.cornerRadius = (CGRectGetHeight(self.frame) - 20) *0.5f;
        _iconImageV.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageV];
    }
    return _iconImageV;
}
/// 名字
-(UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel =[[UILabel alloc]init];
        _nameLabel.font =[UIFont systemFontOfSize: 17];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}
/// 电话
-(UILabel *)phoneNumLabel
{
    if (!_phoneNumLabel)
    {
        _phoneNumLabel =[[UILabel alloc]init];
        _phoneNumLabel.textColor =[UIColor colorWithRed:208 / 255.0f green:208 / 255.0f blue:208 / 255.0f alpha:1];
        [self.contentView addSubview:_phoneNumLabel];
    }
    return _phoneNumLabel;
}
/// 打电话
-(UIButton *)callButton
{
    if (!_callButton)
    {
        _callButton =[[UIButton alloc]init];
        [_callButton setTitle:@"打电话" forState:UIControlStateNormal];
        _callButton.titleLabel.font =[UIFont systemFontOfSize:15.f];
        [_callButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_callButton];
        [_callButton addTarget:self action:@selector(callPersonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callButton;
}
/// 发短信
-(UIButton *)sendMessagerButton
{
    if (!_sendMessagerButton)
    {
        _sendMessagerButton =[[UIButton alloc]init];
        [_sendMessagerButton setTitle:@"发短信" forState:UIControlStateNormal];
        _sendMessagerButton.titleLabel.font =[UIFont systemFontOfSize:15.f];
        [_sendMessagerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_sendMessagerButton];
        [_sendMessagerButton addTarget:self action:@selector(sendMessagerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendMessagerButton;
}

/// 弹框
- (UILabel *)showAlertViewWithTitle:(NSString *)title
{
    UILabel *tell =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 40)];
    tell.backgroundColor = [UIColor colorWithRed:208 / 255.0f green:208 / 255.0f blue:208 / 255.0f alpha:1];
    tell.layer.cornerRadius = 5;
    tell.layer.masksToBounds = YES;
    tell.textAlignment = NSTextAlignmentCenter;
    tell.center = [BBanFViewController currentViewController].view.center;
    tell.text = title;
    [[UIApplication sharedApplication].keyWindow addSubview:tell];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tell removeFromSuperview];
    });
    return tell;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
