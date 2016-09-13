//
//  Person.h
//  TableView
//
//  Created by TechMaster on 3/13/16.
//  Copyright (c) 2016 TechMaster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) int age;
-(id) init: (NSString*) name
    andAge: (int) age;
@end
