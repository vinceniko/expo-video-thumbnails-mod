export default {
    get name() {
        return 'ExpoVideoThumbnails';
    },
    async getThumbnailAsync(sourceUri, destFilepath, options = {}) {
        throw new Error('ExpoVideoThumbnails not supported on Expo Web');
    },
};
//# sourceMappingURL=ExpoVideoThumbnails.web.js.map