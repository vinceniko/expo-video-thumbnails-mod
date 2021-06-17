import { VideoThumbnailsOptions, VideoThumbnailsResult } from './VideoThumbnailsTypes.types';
declare const _default: {
    readonly name: string;
    getThumbnailAsync(sourceUri: string, destFilepath: string, options?: VideoThumbnailsOptions): Promise<VideoThumbnailsResult>;
};
export default _default;
