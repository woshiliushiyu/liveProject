//
//  ViewController.m
//  TestJava
//
//  Created by 流诗语 on 2017/6/8.
//  Copyright © 2017年 刘世玉. All rights reserved.
//

#import "ViewController.h"
#import "PushViewController.h"

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
- (IBAction)uploadBtn:(id)sender {
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",nil];
    
    [manager POST:@"http://127.0.0.1:8080/mfblog/mfblog/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        UIImage * image = [UIImage imageNamed:@"启动3"];
        /// fileData是要上传文件的二进制数据
        NSData *fileData = UIImagePNGRepresentation(image);
        /// 此name主要用于java中获取Part(文件上传组件对象的)，此name值必须是与服务端约定好的固定值，不然服务器到错误的name值时，就无法创建Part对象，最终肯定上传失败的，此name值在HTML5页面中用input标签type="f" 然后设置name值
        NSString *name = @"f";
        /// fileName为文件的名称
        NSString *fileName = [NSString stringWithFormat:@"%@.png", name];
        /// mimeType为文件类型
        NSString *mimeType = @"image/png";
        
        [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"进度是多少呢+%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString * str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"成功+结果%@",str);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败+%@",error);
    }];
}

- (IBAction)sendBtn:(id)sender {
    
//    [self presentViewController:[[PushViewController alloc] init] animated:YES completion:^{
//        
//    }];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",nil];
    
    [manager GET:@"http://localhost:8080/mfblog/mfblog/index?num=1&size=10" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
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
