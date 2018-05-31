//
//  ViewController.m
//  CodeJam
//
//  Created by paul on 5/31/18.
//  Copyright © 2018 Paul. All rights reserved.
//

#import "ViewController.h"
#import "KPILoader.h"
#import "KPIURLList.h"

@interface ViewController ()

@property (nonatomic, retain) UIButton* downloadButton;
@property (nonatomic, retain) UIButton* refrashButton;

@property (atomic, assign) NSUInteger i;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    self.view.backgroundColor = [UIColor whiteColor];


}

-(void) viewWillLayoutSubviews{
    CGRect rect = CGRectMake(self.view.frame.size.width / 4 - 50, self.view.frame.size.height - 40 , 100, 30);
    CGRect rect2 = CGRectMake(self.view.frame.size.width * 3 / 4 - 50, self.view.frame.size.height - 40 , 100, 30);
    
    self.downloadButton = [self buttonSetStatesofTitle:@"Download" plaseRect:rect targetactionSelector:@selector(buttonTapped:)];
    
    self.refrashButton = [self buttonSetStatesofTitle:@"Refresh" plaseRect:rect2 targetactionSelector:@selector(buttonTapped:)];
    
    [self.view addSubview:self.downloadButton];
    [self.view addSubview:self.refrashButton];
    
}

//- (void) layoutViews:(NSArray*) urls{
//    NSMutableArray* views  = [NSMutableArray array];
//    CGRect rect = CGRectMake( 0 , 0 , self.view.frame.size.width, (self.view.frame.size.height - 30) / urls.count);
//    for (id obj in urls) {
//        UIView* temp = [[UIView alloc] initWithFrame:rect];
//        [self.view addSubview:temp];
//    }
//}



-(void) buttonTapped: (UIButton*) button{
    
    if ([button isEqual:self.downloadButton] && !self.i) {
        [self exacuteButtonTap];
    } else{
    
    if ([button isEqual:self.refrashButton] && self.i) {
        [self removeUIImageViewFromSelfView];
        [self exacuteButtonTap];
    }}
}

- (void)removeUIImageViewFromSelfView
{
    for (id child in [self.view subviews])
    {
        if ([child isMemberOfClass:[UIImageView class]])
        {
            [child removeFromSuperview];
        }
    }
}

-(void) exacuteButtonTap{
    KPILoader* newLoader = [[[KPILoader alloc] init] autorelease];
    KPIURLList* newUrlList = [[[KPIURLList alloc]init]autorelease];
    
    NSArray*  urls = [NSArray arrayWithArray:[newUrlList uRLList]];
    self.i = 0;
    [self downloadFromURLS:urls loader:newLoader];
}

- (void) downloadFromURLS: (NSArray*) urls loader:(KPILoader*) newLoader {
    
    
    
    __block NSUInteger overallWidth = 0;
    __block NSUInteger overallHeight = 0;
    
    dispatch_async(dispatch_get_main_queue(), ^{
    overallWidth = self.view.frame.size.width;
    overallHeight = self.view.frame.size.height;
    });

    for (id obj in urls) {
        if ([obj isKindOfClass:[NSString class]]) {
            [newLoader downloadImage:[NSURL URLWithString:obj] withCompletion:^(UIImage * image) {
                UIImageView* newImageView = [[[UIImageView alloc] initWithImage:image] autorelease];
                newImageView.frame = CGRectMake(0, overallHeight * self.i / urls.count / 1.8 + 20, overallWidth, overallHeight / urls.count / 2.5);
                newImageView.contentMode = UIViewContentModeScaleAspectFit;
                NSLog(@"%@", obj);
                
                [self.view addSubview:newImageView];
                self.i++;
            }];
        } else {
            if ([obj isKindOfClass:[NSArray class]]) {
                dispatch_group_t group = dispatch_group_create();
                
                dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
                
                [self downloadFromURLS:obj loader:newLoader];
                    NSLog(@"Group started");
                });
                
                  dispatch_release(group);
                NSLog(@"Group released");
            }
        }
    }
  
}


-(UIButton*) buttonSetStatesofTitle: (NSString*) title plaseRect:(CGRect) valueOfRect targetactionSelector:(SEL) selectorOfAction{
    UIButton* button = [[[UIButton alloc] initWithFrame:valueOfRect] autorelease];
    button.layer.cornerRadius = 7;
    button.showsTouchWhenHighlighted = YES;
    button.backgroundColor = UIColor.grayColor;
    [button setTitle:[NSString stringWithFormat:@"%@", title] forState:UIControlStateNormal];
    [button addTarget:self action:selectorOfAction forControlEvents:UIControlEventTouchUpInside];
    return button;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

