import ExpoVideoThumbnails from './ExpoVideoThumbnails';
import { VideoThumbnailsOptions, VideoThumbnailsResult } from './VideoThumbnailsTypes.types';

export { VideoThumbnailsOptions, VideoThumbnailsResult };

// destFilepath is used for directory structure. the last path component will have its extension replaced with ".jpg"
export async function getThumbnailAsync(
  sourceUri: string,
  destFilepath: string,
  options: VideoThumbnailsOptions = {}
): Promise<VideoThumbnailsResult> {
  return await ExpoVideoThumbnails.getThumbnail(sourceUri, destFilepath, options);
}
