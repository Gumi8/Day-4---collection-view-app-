//
//  PhotoControler.m
//  Photo Collection Day 4
//
//  Created by 123 on 18/06/15.
//  Copyright (c) 2015 Terminal. All rights reserved.
//

#import "PhotoControler.h"
#import <SAMCache/SAMCache.h>

@implementation PhotoControler

+(void)imageForPhoto: (NSDictionary *) photo size: (NSString *) size completion: (void(^) (UIImage *image))completion
{
    if (!photo || !size || !completion) {
        return;
    }
    
    
    NSString *key = [[NSString alloc] initWithFormat:@"%@-%@", photo [@"id"], size];
    UIImage *image = [[SAMCache sharedCache] imageForKey:key];
    
    if (image) {
        completion(image);
        return;
    }

    
    NSURL *url = [[NSURL alloc] initWithString:photo [@"images"] [size] [@"url"]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [[NSData alloc]initWithContentsOfURL:location];
        UIImage *image = [[UIImage alloc] initWithData:data];
        
        [[SAMCache sharedCache] setImage:image forKey:key];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion (image);
        });
        
    }];
    
    [task resume];

}


@end
