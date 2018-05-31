//
//  KPIURLList.m
//  CodeJam
//
//  Created by paul on 5/31/18.
//  Copyright © 2018 Paul. All rights reserved.
//

#import "KPIURLList.h"

@implementation KPIURLList
- (NSMutableArray*) uRLList{
    NSMutableArray  *urls = [NSMutableArray arrayWithObjects:
                             @"https://cdn.pixabay.com/photo/2016/07/18/20/30/tiger-1526704__340.png",
                             @"https://cdn.pixabay.com/photo/2015/11/22/00/08/hourglass-1055711__340.png", nil];
                                
    NSArray* gropOfURL =  @[@"https://cdn.pixabay.com/photo/2017/03/09/20/31/brooch-2130764__340.png",
                            @"https://cdn.pixabay.com/photo/2017/06/20/10/01/ink-2422506__340.png",
                            @"https://cdn.pixabay.com/photo/2016/03/10/03/28/tree-1247796__340.png"];
    
    [urls addObject:gropOfURL];
    //NSLog(@"DOne addition");
    return urls;
}
@end
