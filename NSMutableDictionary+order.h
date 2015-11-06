//
//  NSMutableDictionary+order.h
//  HttpManager
//
//  Created by 刘澈 on 15/11/6.
//  Copyright © 2015年 刘澈. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (order)

- (NSArray *)orderAllKeys;

- (id)orderObjectAtIndex:(NSUInteger)index;

- (void)removeKeyAtIndex:(NSUInteger)index;

@end
