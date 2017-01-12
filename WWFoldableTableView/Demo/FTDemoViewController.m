//
//  FTDemoViewController.m
//  TidusWWDemo
//
//  Created by Tidus on 17/1/5.
//  Copyright © 2017年 Tidus. All rights reserved.
//

#import "FTDemoViewController.h"
#import "UITableView+WWFoldableTableView.h"

#define StatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)
#define NavigationBarHeight (self.navigationController.navigationBar.frame.size.height)
#define TabBarHeight (self.tabBarController.tabBar.frame.size.height)

#define ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)

#define kTableViewHeaderID @"kTableViewHeaderID"

@interface FTDemoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation FTDemoViewController

#pragma mark -init
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupDataList];
    [self.view addSubview:self.tableView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setupDataList
{
    [self.dataList addObject:@"FileManage"];
    [self.dataList addObject:@"ViewControllerTransition"];
    [self.dataList addObject:@"ThreadViewController"];
    [self.dataList addObject:@"MemoryLeak"];
    [self.dataList addObject:@"——————————————————"];
    
}


#pragma mark - getter
- (UITableView *)tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-StatusBarHeight-NavigationBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        //设置可折叠
        _tableView.ww_foldable = YES;
        
    }
    return _tableView;
}

- (NSMutableArray *)dataList
{
    if(!_dataList){
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

#pragma mark - UITableViewDelegate
#pragma mark header/footer
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = nil;
    
    header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kTableViewHeaderID];
    if(!header){
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kTableViewHeaderID];
        UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapped:)];
        [header addGestureRecognizer:tapgr];
    }
    
    if(header){
        header.textLabel.text = [NSString stringWithFormat:@"第%@组", @(section+1)];
        header.tag = section;
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

#pragma mark cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"CELLID";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    NSString *rowData = self.dataList[indexPath.row];
    
    NSString *rowName = rowData;
    NSArray *nameArray = [rowData componentsSeparatedByString:@"-"];
    if(nameArray.count == 2){
        rowName = nameArray[0];
    }
    
    cell.textLabel.text = rowName;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.f;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - gesture
- (void)gestureTapped:(UIGestureRecognizer *)gesture
{
    UIView *header = gesture.view;
    NSInteger section = header.tag;
    [self.tableView ww_foldSection:section fold:![self.tableView ww_isSectionFolded:section]];
    
}
@end
