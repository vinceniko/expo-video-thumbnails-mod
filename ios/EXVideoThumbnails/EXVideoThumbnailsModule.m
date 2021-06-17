// Copyright 2018-present 650 Industries. All rights reserved.

#import <EXVideoThumbnails/EXVideoThumbnailsModule.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import <UIKit/UIKit.h>

static NSString* const OPTIONS_KEY_QUALITY = @"quality";
static NSString* const OPTIONS_KEY_TIME = @"time";
static NSString* const OPTIONS_KEY_HEADERS = @"headers";

@implementation EXVideoThumbnailsModule

UM_EXPORT_MODULE(ExpoVideoThumbnails);

- (void)setModuleRegistry:(UMModuleRegistry *)moduleRegistry
{
  _moduleRegistry = moduleRegistry;
  _fileSystem = [moduleRegistry getModuleImplementingProtocol:@protocol(UMFileSystemInterface)];
}

UM_EXPORT_METHOD_AS(getThumbnail,
                    sourceUri:(NSString *)source
                    destFilepath:(NSString *)dest
                    options:(NSDictionary *)options
                    resolve:(UMPromiseResolveBlock)resolve
                    reject:(UMPromiseRejectBlock)reject)
{
  NSURL *url = [NSURL URLWithString:source];
  if ([url isFileURL]) {
    if (!_fileSystem) {
      return reject(@"E_MISSING_MODULE", @"No FileSystem module.", nil);
    }
    if (!([_fileSystem permissionsForURI:url] & UMFileSystemPermissionRead)) {
      return reject(@"E_FILESYSTEM_PERMISSIONS", [NSString stringWithFormat:@"File '%@' isn't readable.", source], nil);
    }
  }

    dest = [NSURL URLWithString:dest].relativePath;
    NSString *fileName = [[dest.lastPathComponent stringByDeletingPathExtension] stringByAppendingString:@".jpg"];
    NSString *newPath = [[dest stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileName];
    
    NSURL *fileURL = [NSURL fileURLWithPath:newPath];
    NSString *filePath = [fileURL absoluteString];
    NSError *err; // err isn't checked, throw warning
    if ([fileURL checkResourceIsReachableAndReturnError:&err] == YES) {
        UIImage *thumbnail = [UIImage imageWithContentsOfFile:filePath];
        
        return resolve(@{
            @"uri" : filePath,
            @"width" : @(thumbnail.size.width),
            @"height" : @(thumbnail.size.height),
       });
    }

  long timeInMs = [(NSNumber *)options[OPTIONS_KEY_TIME] integerValue] ?: 0;
  float quality = [(NSNumber *)options[OPTIONS_KEY_QUALITY] floatValue] ?: 1.0;
  NSDictionary *headers = options[OPTIONS_KEY_HEADERS] ?: @{};
    
  AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:@{@"AVURLAssetHTTPHeaderFieldsKey": headers}];
  [asset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generator.appliesPreferredTrackTransform = YES;

        CMTime time = CMTimeMake(timeInMs, 1000);

        NSError *err; // err isn't checked, throw warning
        CGImageRef imgRef = [generator copyCGImageAtTime:time actualTime:NULL error:&err];
        if (err) {
          return reject(@"E_THUM_FAIL", err.localizedFailureReason, err);
        }
        UIImage *thumbnail = [UIImage imageWithCGImage:imgRef];

//        err = NULL;
        NSData *data = UIImageJPEGRepresentation(thumbnail, quality);
        if (![data writeToFile:newPath atomically:YES]) {
          return reject(@"E_WRITE_ERROR", @"Can't write to file.", nil);
        }
          
        CGImageRelease(imgRef);  // CGImageRef won't be released by ARC
        
        resolve(@{
                  @"uri" : filePath,
                  @"width" : @(thumbnail.size.width),
                  @"height" : @(thumbnail.size.height),
                  });

  }];
}

@end
