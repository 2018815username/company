//
//  main.m
//  tztMobileApp
//
//  Created by yangdl on 12-11-30.
//  Copyright 2012 投资堂. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {

    //非arc
 NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
