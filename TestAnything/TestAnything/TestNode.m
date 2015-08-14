//
//  TestNode.m
//  TestAnything
//
//  Created by 王露露 on 15/8/12.
//  Copyright (c) 2015年 王露露. All rights reserved.
//

#import "TestNode.h"

@implementation TestNode

- (instancetype)initWithName:(NSString *)name{
    if (self = [super init]) {
        self.name = name;
        SKLabelNode * label = [[SKLabelNode alloc] initWithFontNamed:@"Courier"];
        label.text = @".";
        [self addChild:label];
    }
    return self;
}

@end
