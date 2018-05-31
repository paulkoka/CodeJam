//
//  KPILoader.m
//  CodeJam
//
//  Created by paul on 5/31/18.
//  Copyright © 2018 Paul. All rights reserved.
//

#import "KPILoader.h"

@implementation KPILoader

-(void)downloadImage:(NSURL*)url withCompletion:(void(^_Nullable)(UIImage*))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* imageData = [NSData dataWithContentsOfURL:url];
        UIImage *newImage = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(newImage);
        });
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
