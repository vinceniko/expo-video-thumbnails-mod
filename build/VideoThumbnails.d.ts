import { VideoThumbnailsOptions, VideoThumbnailsResult } from './VideoThumbnailsTypes.types';
export { VideoThumbnailsOptions, VideoThumbnailsResult };
export declare function getThumbnailAsync(sourceUri: string, destFilepath: string, options?: VideoThumbnailsOptions): Promise<VideoThumbnailsResult>;
