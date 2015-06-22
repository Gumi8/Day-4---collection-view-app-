//
//  ViewController.m
//  Photo Collection Day 4
//
//  Created by 123 on 17/06/15.
//  Copyright (c) 2015 Terminal. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCollectionViewCell.h"
#import <SimpleAuth/SimpleAuth.h>
#import "DetailViewController.h"
#import "PresentDetailTransition.h"
#import "dismissDetailTransition.h"


@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) NSString *accessToken;

@property (nonatomic) NSMutableArray *photos;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier: @"Cell"];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
     if (self.accessToken==nil) {
         [SimpleAuth authorize:@"instagram" completion:^(NSDictionary *responseObject, NSError *error)
          {
             self.accessToken = responseObject[@"credentials"] [@"token"];
             [userDefaults setObject:self.accessToken forKey:@"accessToken"];
             [userDefaults synchronize];
             NSLog (@"saved credentials");
              [self downloadImages];

          }];
     } else
     {
         NSLog(@"using previous credentials");
         [self downloadImages];
     }
}
    
#pragma mark - helper method

-(void)downloadImages
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/longdress/media/recent?access_token=%@", self.accessToken];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
   //     NSLog(@"response is %@"), response;
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error: nil];
        NSLog(@"response dictionary is: %@", responseDictionary);
        
        self.photos = responseDictionary[@"data"];
        
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self.collectionView reloadData];
                       });
                   
    }];
    
    [task resume];
}

#pragma mark - UICollectionView methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //return newly created cell
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    // cell.imageView.image = [UIImage imageNamed:@"My_future_car.png"];
    
    // we will parse images from NS dictionary
    
    NSDictionary *photo = self.photos[indexPath.row];
    cell.photo = photo;
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)collectionView: (UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *photo = self.photos[indexPath.row];
    DetailViewController *viewController = [DetailViewController new];
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.photo = photo;
    viewController.transitioningDelegate = self;
    
    
    
    
    [self presentViewController:viewController animated:YES completion:nil];
    
}


#pragma mark - Transitioning delegate methods

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [PresentDetailTransition new];
    
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [dismissDetailTransition new];
}

@end
