//
//  RequestObj.m
//  TestJava
//
//  Created by 流诗语 on 2017/8/18.
//  Copyright © 2017年 刘世玉. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "RequestObj.h"
#import "DKNetworking.h"
#import "TeamModel.h"

@implementation RequestObj

singleton_implementation(RequestObj);

-(RACSignal *)requestLocalJson
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        DKNetworkManager.get(@"questions/experts").cacheType(DKNetworkCacheTypeCacheNetwork).callback(^(DKNetworkRequest *request, DKNetworkResponse *response) {
            NSLog(@"request==>%@     response===>%@",request,response.rawData);
        });
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

-(RACSignal *)requestFormJson:(NSString *)url
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
        [manager GET:@"https://ymzx.asia-cloud.com/api/models/info?id=1" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError * error;
            NSError * err;
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
            if (error) {
                [subscriber sendError:error];
            }
            StatueModel * model = [[StatueModel alloc] initWithDictionary:jsonDic error:&err];
            if (err) {
                [subscriber sendError:error];
            }else{
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            //释放资源
        }];
    }];
}
-(RACSignal *)requestFormAgin
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
        [manager GET:@"https://ymzx.asia-cloud.com/api/questions/experts" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError * error;
            NSError * err;
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
            if (error) {
                [subscriber sendError:error];
            }
//            StatueModel * model = [[StatueModel alloc] initWithString:json error:&err];
            
            if (err) {
                [subscriber sendError:error];
            }else{
                [subscriber sendNext:jsonDic];
                [subscriber sendCompleted];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}
@end
