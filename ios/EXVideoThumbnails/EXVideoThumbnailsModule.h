//  Copyright © 2018 650 Industries. All rights reserved.
#import <UMCore/UMExportedModule.h>
#import <UMCore/UMModuleRegistryConsumer.h>
#import <UMFileSystemInterface/UMFileSystemInterface.h>

@interface EXVideoThumbnailsModule : UMExportedModule <UMModuleRegistryConsumer>

@property (nonatomic, weak) UMModuleRegistry *moduleRegistry;
@property (nonatomic, weak) id<UMFileSystemInterface> fileSystem;

@end
