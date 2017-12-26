//
//  Person.m
//  JavaScriptCore
//
//  Created by Zhiyong Yang on 20/11/2017.
//  Copyright © 2017 ReactNativeInternal. All rights reserved.
//

#import "Person.h"

@implementation Person
- (NSString *)getFullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

+ (instancetype) createWithFirstName:(NSString *)firstName lastName:(NSString *)lastName {
    Person *person = [[Person alloc] init];
    person.firstName = firstName;
    person.lastName = lastName;
    return person;
}
@end
