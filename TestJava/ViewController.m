//
//  ViewController.m
//  TestJava
//
//  Created by 流诗语 on 2017/6/8.
//  Copyright © 2017年 刘世玉. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *contextLabel;
@property (strong, nonatomic) IBOutlet UITextField *addressLabel;
@property (strong, nonatomic) IBOutlet UITextField *durationlabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    
}
- (IBAction)sendBtn:(id)sender {
    
//    @{@"action":@"select",@"name":self.nameLabel.text,@"context":self.contextLabel.text,@"address":self.addressLabel.text,@"duration":self.durationlabel.text}
//    @{@"name":@"名字",@"context":@"描述",@"address":@"北京",@"age":@"20"}
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"text/json",@"application/json", nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://localhost:8080/mfblog/mfblog/index?num=1&size=10" parameters:NULL progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"获取的数据===>%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:NO];
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [[AFHTTPSessionManager manager] POST:@"http://localhost:8080/ServletCarTestDome/RequServlet" parameters:@{@"action":@"action"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"请求回来的数据=====>%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
