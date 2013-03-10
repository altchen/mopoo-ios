//
//  LocalSubstitutionCache.m
//  LocalSubstitutionCache
//
//  Created by Matt Gallagher on 2010/09/06.
//  Copyright 2010 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "LocalSubstitutionCache.h"
#import "MopooRemoteServer.h"
#import "NSString+SSToolkitAdditions.h"
@interface LocalSubstitutionCache(Private)
-(NSString *) getLocalFilePathForUrl:(NSString *) url;
@end
@implementation LocalSubstitutionCache
@synthesize isLoadRemoteImage=_isLoadRemoteImage;
- (NSDictionary *)substitutionPaths
{
    if (cacheLocalDict==nil) {  
        cacheLocalDict =[[NSMutableDictionary alloc] init];
        int count = 10;
        for(int i=0;i<count;i++){
            NSString * obj = [NSString stringWithFormat:@"new/ball%d.gif",i];
            NSString * key = [NSString stringWithFormat:@"https://www.253874.com/new/ball%d.gif",i];
            [cacheLocalDict setObject:obj forKey:key];
        }
        [cacheLocalDict setObject:@"new/leftbg.jpg" forKey:@"https://www.253874.com/new/leftbg.jpg"];
        [cacheLocalDict setObject:@"new/rightbg.jpg" forKey:@"https://www.253874.com/new/rightbg.jpg"];
        [cacheLocalDict setObject:@"new/lsrd.gif" forKey:@"https://www.253874.com/new/lsrd.gif"];
    }
    return cacheLocalDict;
}

- (NSString *)mimeTypeForPath:(NSString *)originalPath
{
	//
	// Current code only substitutes PNG images
	//
	return @"image/png";	
}
-(NSString *) getLocalFilePathForUrl:(NSString *)url
{
    if (cacheFilePath ==NULL){
        cacheFilePath = [[NSMutableDictionary alloc] init];
    }
    NSString * path = [cacheFilePath objectForKey:url];
    if (path !=nil){
        return path;
    }
    NSString * rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * cacheRootPath = [rootPath stringByAppendingPathComponent:@"cachefile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cacheRootPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheRootPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString * localFilePath =  [cacheRootPath stringByAppendingPathComponent:[url MD5Sum]];
    [cacheFilePath setObject:localFilePath forKey:url];
    //ACLog(@"md5 file path:%@", localFilePath);
    return localFilePath;
}
- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request
{
	//
	// Get the path for the request
	//
	NSString *pathString = [[request URL] absoluteString];
	ACLog(@"NSURLCache请求地址：%@",pathString);
	//
	// See if we have a substitution file for this path
	//
	NSString *substitutionFileName = [[self substitutionPaths] objectForKey:pathString];
	if (!substitutionFileName)
	{
		//
		// No substitution file, return the default cache response
		//
        if ([pathString hasPrefix:@"https://www.253874.com/new/face/"]
            || [pathString hasPrefix:@"https://www.253874.com/upf/"]
            || [pathString hasPrefix:@"https://www.253874.com/new/flag/"]) {
         
            NSData *data =nil;
            NSString * localFilePath = [self getLocalFilePathForUrl:pathString];
            if ([[NSFileManager defaultManager] fileExistsAtPath:localFilePath]){
                data = [NSData dataWithContentsOfFile:localFilePath];
            }else{
                if (_isLoadRemoteImage) {
                    data = [[MopooRemoteServer sharedRemoteServer] fetchDataWithUrl:pathString];  
                }else{
                    data = [@"" dataUsingEncoding:NSASCIIStringEncoding];
                }

                if (data !=nil){
                    [data writeToFile:localFilePath atomically:YES];
                }
            }                
            if(data !=nil){
                NSURLResponse *response =
                [[NSURLResponse alloc]
                  initWithURL:[request URL]
                  MIMEType:[self mimeTypeForPath:pathString]
                  expectedContentLength:[data length]
                  textEncodingName:nil];
                NSCachedURLResponse * cachedResponse =
                [[NSCachedURLResponse alloc] initWithResponse:response data:data];
                return cachedResponse;
            }else{
                return [super cachedResponseForRequest:request];
            }
            //
            // Create the cacheable response
            //

        }else{
            return [super cachedResponseForRequest:request];
        }
	}
	
	//
	// If we've already created a cache entry for this path, then return it.
	//
	NSCachedURLResponse *cachedResponse = [cachedResponses objectForKey:pathString];
	if (cachedResponse)
	{
		return cachedResponse;
	}
	
	//
	// Get the path to the substitution file
	//
	NSString *substitutionFilePath =
		[[NSBundle mainBundle]
			pathForResource:[substitutionFileName stringByDeletingPathExtension]
			ofType:[substitutionFileName pathExtension]];
	//NSAssert(substitutionFilePath, @"File %@ in substitutionPaths didn't exist", substitutionFileName);
	
	//
	// Load the data
	//
	NSData *data = [NSData dataWithContentsOfFile:substitutionFilePath];
	
	//
	// Create the cacheable response
	//
	NSURLResponse *response =
		[[NSURLResponse alloc]
			initWithURL:[request URL]
			MIMEType:[self mimeTypeForPath:pathString]
			expectedContentLength:[data length]
			textEncodingName:nil];
	cachedResponse =
		[[NSCachedURLResponse alloc] initWithResponse:response data:data];
	
	//
	// Add it to our cache dictionary
	//
	if (!cachedResponses)
	{
		cachedResponses = [[NSMutableDictionary alloc] init];
	}
	[cachedResponses setObject:cachedResponse forKey:pathString];
	
	return cachedResponse;
}

- (void)removeCachedResponseForRequest:(NSURLRequest *)request
{
	//
	// Get the path for the request
	//
	NSString *pathString = [[request URL] path];
	if ([cachedResponses objectForKey:pathString])
	{
		[cachedResponses removeObjectForKey:pathString];
	}
	else
	{
		[super removeCachedResponseForRequest:request];
	}
}

- (void)dealloc
{
	cachedResponses = nil;
    cacheLocalDict = nil;
    cacheFilePath = nil;
}

@end
