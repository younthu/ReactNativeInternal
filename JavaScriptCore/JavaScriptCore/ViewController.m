//
//  ViewController.m
//  JavaScriptCore
//
//  Created by Zhiyong Yang on 20/11/2017.
//  Copyright © 2017 ReactNativeInternal. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import "ViewController.h"
#import "Person.h"
const NSString *js = @"var loadPeopleFromJSON = function(jsonString) {\
var data = JSON.parse(jsonString);\
var people = [];\
for (i = 0; i < data.length; i++) {\
    var person = Person.createWithFirstNameLastName(data[i].first, data[i].last);\
    person.birthYear = data[i].year;\
    \
    people.push(person);\
}\
console.log('God bless you!'); \
return people;\
}";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

// all these demo code comes from http://nshipster.cn/javascriptcore/
- (void)runJavaScriptInJSC {
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"var num = 5 + 5"];
    [context evaluateScript:@"var names = ['Grace', 'Ada', 'Margaret']"];
    [context evaluateScript:@"var triple = function(value) { return value * 3 }"];
    JSValue *tripleNum = [context evaluateScript:@"triple(num)"];
    
    NSLog(@"Tripled: %d", [tripleNum toInt32]);
    // Tripled: 30
    
    JSValue *tripleFunction = context[@"triple"];
    JSValue *result = [tripleFunction callWithArguments:@[@5] ];
    NSLog(@"Five tripled: %d", [result toInt32]);
}
- (void)nativeToJsCall {
    
    JSContext *context = [[JSContext alloc] init];
    context[@"simplifyString"] = ^(NSString *input) {
        NSMutableString *mutableString = [input mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
        [mutableString appendString:@"great"];
        return mutableString;
    };
    
    NSLog(@"%@", [context evaluateScript:@"simplifyString('Fuck me! fuck me! Fuck me!')"]);
}

- (IBAction)createNativeInstance:(id)sender {
    // export Person class
    JSContext *context = [[JSContext alloc] init];
    context[@"Person"] = [Person class];
    
    // load Mustache.js
    NSError *error ;
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"mustache"
                                                         ofType:@"js"];
    NSString *mustacheJSString = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
    [context evaluateScript:mustacheJSString];
    context[@"console"][@"log"] = ^(NSString *s){
        NSLog(@"Console:%@",s);
    };
    
    [context evaluateScript:js];
    // get JSON string
    NSString *peopleJSON = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"person" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    
    // get load function
    JSValue *load = context[@"loadPeopleFromJSON"];
    // call with JSON and convert to an NSArray
    JSValue *loadResult = [load callWithArguments:@[peopleJSON]];
    NSArray *people = [loadResult toArray];
    
    // get rendering function and create template
    JSValue *mustacheRender = context[@"Mustache"][@"render"];
    NSString *template = @"{{getFullName}}, born {{birthYear}}";
    
    // loop through people and render Person object as string
    for (Person *person in people) {
        NSLog(@"%@", [mustacheRender callWithArguments:@[template, person]]);
    }
    
    // Output:
    // Grace Hopper, born 1906
    // Ada Lovelace, born 1815
    // Margaret Hamilton, born 1936
}


- (void)exceptionHandler{
    
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"JS Error: %@", exception);
    };
    
    [context evaluateScript:@"function multiply(value1, value2) { return value1 * value2 "];
    // JS Error: SyntaxError: Unexpected end of script
}

- (void)nativeClass {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
