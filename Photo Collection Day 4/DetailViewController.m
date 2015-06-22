//
//  DetailViewController.m
//  Photo Collection Day 4
//
//  Created by 123 on 18/06/15.
//  Copyright (c) 2015 Terminal. All rights reserved.
//

#import "DetailViewController.h"
#import "PhotoControler.h"



@interface DetailViewController ()

@property (nonatomic) UIImageView* imageview;

@property (nonatomic) UIDynamicAnimator *animator;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.95]];
     
     self.imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, -320.f, 320.f, 320.f)];
      [self.view addSubview:self.imageview];
      
     [PhotoControler imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
         self.imageview.image = image;
     }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.view  addGestureRecognizer:tap];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.imageview snapToPoint:self.view.center]
    ;
    [self.animator addBehavior:snap];
    

}


-(void) close {
    
    [self.animator removeAllBehaviors];
   
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.imageview
                                                    snapToPoint:CGPointMake (CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds)+180.f)];
     [self.animator addBehavior:snap];
     
      [self dismissViewControllerAnimated:YES completion: nil];
          

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
