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
@property (nonatomic, retain) UIView* gropeOfPictures;
@property (nonatomic, assign) NSUInteger numberOfRows;

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


-(void) buttonTapped: (UIButton*) button{
    
    if ([button isEqual:self.downloadButton] && !self.i) {
        [self exacuteButtonTap];
    } else{
        
        if ([button isEqual:self.refrashButton] && self.i) {
//            double delayInSeconds = 3.0;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.refrashButton.enabled = NO;
          //  });
            [self removeUIImageViewFromSelfView];
            [self exacuteButtonTap];
        }}
}

- (void)removeUIImageViewFromSelfView
{
    for (id child in [self.view subviews])
    {
        if ([child isMemberOfClass:[UIImageView class]] || [child isMemberOfClass:[UIView class]] )
        {
            [child removeFromSuperview];
        }
    }
}

-(void) exacuteButtonTap{
    KPILoader* newLoader = [[[KPILoader alloc] init] autorelease];
    KPIURLList* newUrlList = [[[KPIURLList alloc]init]autorelease];
    
    NSArray*  urls = [NSArray arrayWithArray:[newUrlList uRLList]];
    
    self.numberOfRows = urls.count;
    
    self.i = 0;
    [self downloadFromURLS:urls loader:newLoader];
}

-(CGRect) currentRectPlace{
    return  CGRectMake(0, self.view.frame.size.height * self.i / self.numberOfRows / 1.8 + 20, self.view.frame.size.width, self.view.frame.size.height / self.numberOfRows / 2.5);
}


- (void) downloadFromURLS: (NSArray*) urls loader:(KPILoader*) newLoader {
    
    for (id obj in urls) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSLog(@"%@", obj);
            [newLoader downloadImage:[NSURL URLWithString:obj]
                      withCompletion:^(UIImage * image) {
                          [self layoutDouwnloadedSinglePictures:image];
                          
                      }];   } else {
                          
                          if ([obj isKindOfClass:[NSArray class]]) {
                               [self layoutDouwnloadedGroupOfPictures:obj loader:newLoader];
                      }
            }
    
    }
    
}

-(void) layoutDouwnloadedSinglePictures:(UIImage*)image{
    UIImageView* newImageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    
    newImageView.frame = [self currentRectPlace];
    newImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:newImageView];
    self.i++;
    
}


-(void) layoutDouwnloadedGroupOfPictures: (NSArray*) urls loader:(KPILoader*) newLoader{
    NSMutableArray* images = [[NSMutableArray alloc] init];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    
    for (NSString* obj in urls) {
        dispatch_group_async(group, queue, ^{
            dispatch_group_enter(group);
            [newLoader downloadImage:[NSURL URLWithString:obj] withCompletion:^(UIImage * image) {
                UIImageView* newImageView = [[[UIImageView alloc] initWithImage:image] autorelease];
                 [images addObject:newImageView];
                 dispatch_group_leave(group);
            }];
            
        });
    }
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.gropeOfPictures = [[[UIView alloc] initWithFrame:self.currentRectPlace] autorelease];
       
        self.i++;
        
        NSUInteger x = 0;
        for (UIImageView* obj in images) {
            obj.frame = CGRectMake(self.gropeOfPictures.frame.size.width * x / images.count + 50, 0, self.gropeOfPictures.frame.size.height , self.gropeOfPictures.frame.size.height);
            x++;
            [self.gropeOfPictures addSubview:obj];
        }
        
        [self.view addSubview:self.gropeOfPictures];
        [self.gropeOfPictures setNeedsDisplay];
        NSLog(@"all done");
        
        });
    
    dispatch_release(group);
    self.refrashButton.enabled = YES;
    [images release];
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
