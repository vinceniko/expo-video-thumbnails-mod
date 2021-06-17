import { VideoThumbnailsOptions, VideoThumbnailsResult } from './VideoThumbnailsTypes.types';

export default {
  get name(): string {
    return 'ExpoVideoThumbnails';
  },
  async getThumbnailAsync(
    sourceUri: string,
    destFilepath: string,
    options: VideoThumbnailsOptions = {}
  ): Promise<VideoThumbnailsResult> {
    throw new Error('ExpoVideoThumbnails not supported on Expo Web');
  },
};
