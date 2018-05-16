
//
//  BBanAddressListController.m
//  QNTest
//
//  Created by 山神 on 2018/5/16.
//  Copyright © 2018年 山神. All rights reserved.
//

#import "BBanAddressListController.h"
#import "BBanAddressListTabCell.h"
#import "BBanAddressAPI.h"

static NSString *const BBanAddressListCellID = @"addressListCellID";

@interface BBanAddressListController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(nonatomic,copy) NSArray<BBanSectionPerson *> *dataArr;  // 数据源
@property (nonatomic, copy) NSArray<NSString *> *keys;  // 排序key
@property(nonatomic,strong) UITableView *backTableView;  // 数据表
@property(nonatomic,strong) UISearchBar *searchBar;  // 搜索框
@property(nonatomic,assign) BOOL isSearchResult;  // 搜索的结果
@property(nonatomic,strong) NSMutableArray<BBanAddressPerson *> *searchResultArr;  // 搜索的结果
@end

@implementation BBanAddressListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isSearchResult = NO;
    [self _setupUI];
    [self _loadData];
    [self _listenAddressChange];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isSearchResult = NO;
}

#pragma mark Tableview 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearchResult)
    {
        return self.searchResultArr.count;
    }
    BBanSectionPerson *sectionModel = self.dataArr[section];
    return sectionModel.persons.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBanAddressListTabCell *cell = [tableView dequeueReusableCellWithIdentifier:BBanAddressListCellID forIndexPath:indexPath];
    cell.selectionStyle = NO;
    if (self.isSearchResult)
    {
        if (self.searchResultArr.count > indexPath.row)
        {
            BBanAddressPerson *mode = self.searchResultArr[indexPath.row];
            cell.model = mode;
            return cell;
        }
        else
        {
            return nil;
        }
    }
    if (self.dataArr.count > indexPath.section)
    {
        BBanSectionPerson *sectionModel = self.dataArr[indexPath.section];
        if (sectionModel.persons.count > indexPath.row)
        {
            BBanAddressPerson *personModel = sectionModel.persons[indexPath.row];
            cell.model = personModel;
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isSearchResult)
    {
        return 1;
    }
    return self.dataArr.count;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.isSearchResult)
    {
        return nil;
    }
    return self.keys;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.isSearchResult)
    {
        return nil;
    }
    BBanSectionPerson *sectionModel = self.dataArr[section];
    return sectionModel.key;
}

-(void)_setupUI
{
    UITableView *tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView =[UIView new];
    tableview.rowHeight = 80;
    
    [tableview registerClass:[BBanAddressListTabCell class] forCellReuseIdentifier:BBanAddressListCellID];
    [self.view addSubview:tableview];
    self.backTableView = tableview;
    
    UIView *searchBackView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    tableview.tableHeaderView = searchBackView;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 60, 44)]; // 不设置高度直接使用默认的高度
    self.searchBar = searchBar;
    
    searchBar.delegate = self;
    searchBar.barTintColor = [UIColor whiteColor]; //[UIColor colorWithRed:59 / 255.0f green:59 / 255.0f blue:59 / 255.0f alpha:1];
    for (UIView *subView in [[searchBar.subviews lastObject] subviews])
    {
        if ([subView isKindOfClass:[UITextField class]])
        {
            UITextField *textField = (UITextField *) subView;
            textField.backgroundColor = [UIColor colorWithRed:187 / 255.0f green:187 / 255.0f blue:187 / 255.0f alpha:1];// [IJSFColor colorWithR:187 G:187 B:187 alpha:1];
            textField.textColor = [UIColor whiteColor]; //修改输入的字体的颜色
            //  [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];  //修改placeholder的颜色
        }
    }
    searchBar.placeholder = @"搜索通讯录好友名字";
//    searchBar.showsCancelButton = YES; //取消按钮
    [searchBar setBackgroundImage:[[UIImage alloc] init]];  // 取消搜索框的边界线
    
    UIButton *cancelButton =[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchBar.frame), 0, 40, 44)]; //[searchBar valueForKey:@"cancelButton"];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [searchBackView addSubview:searchBar];
    [searchBackView addSubview:cancelButton];
}

#pragma mark-----------------------搜索框的监听------------------------------
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchResultArr removeAllObjects];
    self.isSearchResult = YES;
    [searchBar resignFirstResponder]; // 隐藏键盘
    [[BBanAddressManager sharedInstance] accessContactsComplection:^(BOOL succeed, NSArray<BBanAddressPerson *> *contacts) {
        [contacts enumerateObjectsUsingBlock:^(BBanAddressPerson * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.fullName containsString:searchBar.text])
            {
                [self.searchResultArr addObject:obj];
            }
            [self.backTableView reloadData];
        }];
    }];
}
- (void)cancelButtonAction:(UIButton *)button
{
    self.isSearchResult = NO;
    [self.searchResultArr removeAllObjects];
    [self _loadData];
}

#pragma mark -  加载数据
-(void)_loadData
{
    [[BBanAddressManager sharedInstance] accessSectionContactsComplection:^(BOOL succeed, NSArray<BBanSectionPerson *> *contacts, NSArray<NSString *> *keys) {
        self.dataArr = contacts;
        self.keys = keys;
        [self.backTableView reloadData];
    }];
}
#pragma mark -  监听通讯录的变化
-(void)_listenAddressChange
{
    __weak typeof (self) weakSelf = self;
    [BBanAddressManager sharedInstance].contactChangeHandler = ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf _loadData];
    };
}

#pragma mark 懒加载区域
-(NSMutableArray *)searchResultArr
{
    if (_searchResultArr == nil)
    {
        _searchResultArr =[NSMutableArray array];
    }
    return _searchResultArr;
}























- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

@end
