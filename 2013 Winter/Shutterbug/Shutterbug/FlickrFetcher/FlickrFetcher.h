//
//  FlickrFetcher.h
//
//  Created for Stanford CS193p Winter 2013.
//  Copyright 2013 Stanford University
//  All rights reserved.
//

#import <Foundation/Foundation.h>

// tags in the photo dictionaries returned from stanfordPhotos or latestGeoreferencedPhotos

#define FLICKR_PHOTO_TITLE @"title"
#define FLICKR_PHOTO_DESCRIPTION @"description._content"  // must use valueForKeyPath: on this one
#define FLICKR_PLACE_NAME @"_content"
#define FLICKR_PHOTO_ID @"id"
#define FLICKR_LATITUDE @"latitude"
#define FLICKR_LONGITUDE @"longitude"
#define FLICKR_PHOTO_OWNER @"ownername"
#define FLICKR_PHOTO_PLACE_NAME @"derived_place"  // doesn't work for Stanford photos
#define FLICKR_TAGS @"tags"

#define NSLOG_FLICKR NO

typedef enum {
	FlickrPhotoFormatSquare = 1,    // 75x75
	FlickrPhotoFormatLarge = 2,     // 1024x768
	FlickrPhotoFormatOriginal = 64  // at least 1024x768
} FlickrPhotoFormat;

@interface FlickrFetcher : NSObject

// fetch a bunch of Flickr photo dictionaries using the Flickr API
+ (NSArray *)stanfordPhotos;

// get the URL for a Flickr photo given a dictionary of Flickr photo info
//  (which can be gotten using stanfordPhotos or latestGeoreferencedPhotos)
+ (NSURL *)urlForPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format;

// fetch a bunch of recently taken georeferenced Flickr photo dictionaries
+ (NSArray *)latestGeoreferencedPhotos;

@end
