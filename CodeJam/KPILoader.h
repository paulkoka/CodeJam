//
//  KPILoader.h
//  CodeJam
//
//  Created by paul on 5/31/18.
//  Copyright © 2018 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KPILoader : UIImageView
-(void)downloadImage:(NSURL*)url withCompletion:(void(^_Nullable)(UIImage*))completion;
@end
