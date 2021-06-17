import ExpoVideoThumbnails from './ExpoVideoThumbnails';
// destFilepath is used for directory structure. the last path component will have its extension replaced with ".jpg"
export async function getThumbnailAsync(sourceUri, destFilepath, options = {}) {
    return await ExpoVideoThumbnails.getThumbnail(sourceUri, destFilepath, options);
}
//# sourceMappingURL=VideoThumbnails.js.map