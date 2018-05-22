//
//  ReqController.m
//  TestJava
//
//  Created by 流诗语 on 2017/8/18.
//  Copyright © 2017年 刘世玉. All rights reserved.
//

#import "ReqController.h"
#import "RequestObj.h"
#import "StatueModel.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "DKNetworking.h"
#import "TeamModel.h"
@interface ReqController ()
@property(nonatomic,strong)StatueModel * model;
@end

@implementation ReqController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"获取缓存大小===>%@",[DKNetworkCache cacheSize]);
    

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"请求" style:UIBarButtonItemStylePlain target:self action:@selector(didNavBtnClick)];
}
- (void)didNavBtnClick {
    
    RACSignal * s1 = [[RequestObj sharedRequestObj] requestFormJson:nil];
    RACSignal * s3 = [[RequestObj sharedRequestObj] requestLocalJson];
    RACSignal * s2 = [[RequestObj sharedRequestObj] requestFormAgin];
    
//    //串行(前面执行完了在执行后面 s1->s2->s3)
//    [[[s1 then:^RACSignal * _Nonnull{
//        return s2;
//    }] then:^RACSignal * _Nonnull{
//        return s3;
//    }] subscribeNext:^(StatueModel *  _Nullable model) {
//        NSLog(@"获取的串行数据===>%@",model);
//    } error:^(NSError * _Nullable error) {
//        NSLog(@"执行错误回调");
//    } completed:^{
//        NSLog(@"串行执行完毕");
//    }];
    
    
    //并行(一起执行);
    [[RACSignal combineLatest:@[s1,s2,s3]] subscribeNext:^(RACTuple *  _Nullable value) {
        NSLog(@"并行执行结果===>%@",value);
        self.model = value[0];
    } error:^(NSError * _Nullable error) {
        NSLog(@"并行执行错误");
    } completed:^{
        NSLog(@"并行执行完毕");
        [self.tableView reloadData];
    }];
    
//    [[[RequestObj sharedRequestObj] requestFormJson:nil] subscribeNext:^(StatueModel *  _Nullable model) {
//        NSLog(@"%@",model);
//        self.model = model;
//    } error:^(NSError * _Nullable error) {
//        NSLog(@"失败===%@",error.userInfo);
//    } completed:^{
//        NSLog(@"完成");
//        [self.tableView reloadData];
//    }];

    
    //RAC 调用
//    [DKNetworkManager.get(@"https://ymzx.asia-cloud.com/api/questions/experts").executeSignal subscribeNext:^(RACTuple *  _Nullable x) {
//        NSLog(@"链式反应===>%@",x);
//    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.data.groups.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithString:NSStringFromClass([UITableViewCell class])]];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithString:NSStringFromClass([UITableViewCell class])]];
    }
    DescriptModel * subModel = self.model.data.groups[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"ywjf"];
    cell.textLabel.text = subModel.name;
//    cell.detailTextLabel.text = subModel.mobile;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
