//
//  LocationController.m
//  TestJava
//
//  Created by 流诗语 on 2017/8/23.
//  Copyright © 2017年 刘世玉. All rights reserved.
//

#import "LocationController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <CoreLocation/CoreLocation.h>
@interface LocationController ()<CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *persionLabel;
@property(nonatomic,strong)CLLocationManager * manager;
@property(nonatomic,strong)CLGeocoder * geocoder;
@end

@implementation LocationController
-(CLLocationManager *)manager
{
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
    }
    return _manager;
}
-(CLGeocoder *)geocoder
{
    if (!_geocoder) {
        
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
-(RACSignal * )authorizedSignal
{
    //判断是否获取了用户授权,如果没有授权 那么就去获取
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        [self.manager requestAlwaysAuthorization];
        
        return [[self rac_signalForSelector:@selector(locationManager:didChangeAuthorizationStatus:) fromProtocol:@protocol(CLLocationManagerDelegate)] map:^id _Nullable(id  _Nullable value) {
            
            return @([value[1] integerValue] == kCLAuthorizationStatusAuthorizedAlways);
            
        }];
    }
    return [RACSignal return:@([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [[[[[self authorizedSignal] filter:^BOOL(id  _Nullable value) {
        
        return [value boolValue];
        
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        
        return [[[[[self rac_signalForSelector:@selector(locationManager:didUpdateLocations:) fromProtocol:@protocol(CLLocationManagerDelegate)] map:^id _Nullable(id  _Nullable value) {
            
            return value[1];
            
//        }] merge:[self rac_signalForSelector:@selector(locationManager:didFailWithError:) fromProtocol:@protocol(CLLocationManagerDelegate)]] map:^id _Nullable(id  _Nullable value) {
//
//            return [RACSignal error:value[0]];
            
        }] take:1] initially:^{
            
            [self.manager startUpdatingLocation];
            
        }] finally:^{
            
            [self.manager stopUpdatingLocation];
            
        }];
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        CLLocation * location = [value firstObject];
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                
                if (error) {
                    
                    [subscriber sendError:error];
                }else{
                    
                    [subscriber sendNext:[placemarks firstObject]];
                    [subscriber sendCompleted];
                }
            }];
            return [RACDisposable disposableWithBlock:^{}];
        }];
    }] subscribeNext:^(id  _Nullable x) {
        
        self.persionLabel.text = [x addressDictionary][@"Name"];
    }];
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
