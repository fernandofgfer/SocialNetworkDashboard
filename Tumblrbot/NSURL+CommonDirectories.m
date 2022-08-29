//
//  NSURL+CommonDirectories.m
//  Tumblrbot
//
//  Created by Brian Michel on 3/29/16.
//  Copyright © 2016 Tumblr. All rights reserved.
//

#import "NSURL+CommonDirectories.h"

@implementation NSURL (CommonDirectories)

+ (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.tumblr.Tumblrbot" in the application's documents Application Support directory.
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSArray <NSURL *> *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];

    NSURL *applicationDocumentsURL = URLs.lastObject;

    if (!applicationDocumentsURL) {
        NSLog(@"Unable to get application Documents directory URL, something is seriously bad.");
        abort();
    }

    return applicationDocumentsURL;
}

@end
