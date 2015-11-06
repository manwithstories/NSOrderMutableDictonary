//
//  NSMutableDictionary+order.m
//  HttpManager
//
//  Created by 刘澈 on 15/11/6.
//  Copyright © 2015年 刘澈. All rights reserved.
//

#import "NSMutableDictionary+order.h"
#import  <objc/runtime.h>

const char* OrderListKey = "ORDER_LIST_PROPERTY_KEY";

@interface NSMutableDictionary()

@property (nonatomic,strong)NSMutableArray *orderList;

@end

@implementation NSMutableDictionary (order)



+(void)exchangeMethodBySEL:(NSString *)sel Class:clazz

{
    SEL originalSelector = NSSelectorFromString(sel);
    NSString *swizzledSEL = [NSString stringWithFormat:@"swizzled_%@",sel];
    SEL swizzledSelector = NSSelectorFromString(swizzledSEL);
    
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    class_addMethod(clazz,
                    originalSelector,
                    class_getMethodImplementation(clazz, originalSelector),
                    method_getTypeEncoding(originalMethod));
    
    class_addMethod(self,
                    swizzledSelector,
                    class_getMethodImplementation(self, swizzledSelector),
                    method_getTypeEncoding(swizzledMethod));
    
    method_exchangeImplementations(originalMethod, swizzledMethod);

}



+(void)load
{
    
    Class clazz  = NSClassFromString([[NSString alloc]
                                      initWithData:[[NSData alloc]
                                                    initWithBase64EncodedString:@"X19OU0RpY3Rpb25hcnlN" options:0] encoding:NSUTF8StringEncoding]);
    if(clazz != nil){
        [self exchangeMethodBySEL:@"setObject:forKey:" Class:clazz];
        [self exchangeMethodBySEL:@"removeObjectForKey:" Class:clazz];
        [self exchangeMethodBySEL:@"removeAllObjects" Class:clazz];
        [self exchangeMethodBySEL:@"removeObjectsForKeys:" Class:clazz];
    }
}


-(void)setOrderList:(NSMutableArray *)orderList
{
    objc_setAssociatedObject(self,&OrderListKey,orderList,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableArray *)orderList
{
    return objc_getAssociatedObject(self,&OrderListKey);
}

- (void)swizzled_setObject:(id)anObj forKey:(id)aKey
{
    if(self.orderList == nil){
        self.orderList = [NSMutableArray array];
    }
    if(![self.orderList containsObject:aKey]){
        [self.orderList addObject:aKey];
    }
    [self swizzled_setObject:anObj forKey:aKey];
}


- (void)swizzled_removeObjectForKey:(id)anObj
{
    if(self.orderList != nil && [self.orderList containsObject:anObj]){
        [self.orderList removeObject:anObj];
    }
    [self swizzled_removeObjectForKey:anObj];
}

- (void)swizzled_removeAllObjects
{
    if(self.orderList != nil){
        [self.orderList removeAllObjects];
    }
    [self swizzled_removeAllObjects];
}

- (void)swizzled_removeObjectsForKeys:(NSArray *)keys
{
    if(self.orderList != nil){
        [self.orderList removeObjectsInArray:keys];
    }
    [self swizzled_removeObjectsForKeys:keys];
}


/////////////////////////////////////分割线,上面是运行时hook下面是业务代码///////////////////////////////////////

- (NSArray *)orderAllKeys
{
    return [NSArray arrayWithArray:self.orderList];
}

- (id)orderObjectAtIndex:(NSUInteger)index
{
    if([self.orderList count]>0 && index < [self.orderList count]){
        id key = [self.orderList objectAtIndex:index];
        return [self objectForKey:key];
    }else{
        return nil;
    }
}

- (void)removeKeyAtIndex:(NSUInteger)index
{
    if([self.orderList count]>0 && index < [self.orderList count]){
        id key = [self.orderList objectAtIndex:index];
        [self removeObjectForKey:key];
    }
}
@end
