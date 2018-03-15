//
//  StatueModel.h
//  TestJava
//
//  Created by 流诗语 on 2017/8/18.
//  Copyright © 2017年 刘世玉. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "DescriptModel.h"


@protocol DescriptModel

@end

@interface StatueModel : JSONModel
@property(nonatomic,copy)NSString <Optional>* status_code;
@property(nonatomic,copy)NSString <Optional>* message;
@property(nonatomic,strong)DescriptModel <Optional>* data;

@end
