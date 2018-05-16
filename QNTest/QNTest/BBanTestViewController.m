//
//  BBanTestViewController.m

//  QNTest
//
//  Created by 山神 on 2018/5/16.
//  Copyright © 2018年 山神. All rights reserved.
//

#import "BBanTestViewController.h"
#import "BBanAddressListController.h"


@interface BBanTestViewController ()

@end

@implementation BBanTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}


- (IBAction)pushAction:(UIButton *)sender
{
    BBanAddressListController *vc =[[BBanAddressListController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)presentAction:(UIButton *)sender
{
    BBanAddressListController *vc =[BBanAddressListController new];
    [self presentViewController:vc animated:YES completion:nil];
}





@end
