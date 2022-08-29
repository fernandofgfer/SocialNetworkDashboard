//
//  NSURL+CommonDirectories.h
//  Tumblrbot
//
//  Created by Brian Michel on 3/29/16.
//  Copyright © 2016 Tumblr. All rights reserved.
//

@import Foundation;

@interface NSURL (CommonDirectories)

/**
 *  The sandbox documents directory.
 *
 *  @return A URL describing the location of the documents directory.
 */
+ (nonnull NSURL *)applicationDocumentsDirectory;

@end
