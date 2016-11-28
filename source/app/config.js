/**
 * @namespace Config
 *
 * @property {array} manifest - array for preloaded files
 *
 * @property {object} canvas - default canvas settings
 * @property {string} canvas.id - canvas DOM ID
 * @property {number} canvas.width - canvas width
 * @property {number} canvas.height - canvas height
 *
 * @property {object} stage - default stage settings
 * @property {number} stage.fps - stage framerate
 */
module.exports = {
  manifest: [
    { src: 'assets/bg.png', id: 'mainSceneBg' },
  ],
  canvas: {
    id: 'main',
    width: 1920,
    height: 1080,
  },
  stage: {
    fps: 20,
  },
};
