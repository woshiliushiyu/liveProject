//
//  DescriptModel.h
//  TestJava
//
//  Created by 流诗语 on 2017/8/18.
//  Copyright © 2017年 刘世玉. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "LayoutModel.h"

@protocol LayoutModel

@end


@interface DescriptModel : JSONModel
@property(nonatomic,copy)NSString <Optional>* id;
@property(nonatomic,copy)NSString <Optional>* name;
@property(nonatomic,copy)NSString <Optional>* title;
@property(nonatomic,strong)NSArray <LayoutModel>* groups;
@end
