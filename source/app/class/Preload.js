/* eslint-disable import/no-extraneous-dependencies, import/extensions, import/no-unresolved */
import { LoadQueue } from 'PreloadJS';
import { Tween, Ease } from 'TweenJS';
/* eslint-enable import/no-extraneous-dependencies, import/extensions, import/no-unresolved */

import config from '../config';
import utils from '../modules/utils';
import Game from './Game';

/**
 * Preload class used for loading content
 */
export default class Preload {

  /**
   * Calling init method
   * @returns {object} Promise Preload promise
   */
  constructor() {
    return new utils._Promise((resolve) => {
      this.init(resolve);
    });
  }

  /**
   * Sets up game loader. Resolve promise when loading is complete.
   * @param {object} Resolve Promise resolve
   */
  init(resolve) {
    this.createTextLoader();

    this.loader = new LoadQueue(false);
    this.loader.on('error', this.constructor.handleFileError, this);
    this.loader.on('fileload', this.constructor.handleFileLoad, this);
    this.loader.on('progress', this.handleProgress.bind(this), this);
    this.loader.on('complete', this.handleComplete.bind(this, () => resolve()));
    this.loader.loadManifest(config.manifest);
  }

  /**
   * Create graphic loader for manifest.
   */
  createTextLoader() {
    this.graphicLoader = utils.drawTextShape(0, 0, config.canvas.width, config.canvas.height, '#fff', 'Loading', '#9b59b6');

    this.textLoader = this.graphicLoader.getChildByName('mainText');
    Game.STAGE.addChild(this.graphicLoader);
  }

  /**
   * Erase graphic loader.
   */
  eraseTextLoader() {
    Game.STAGE.removeChild(this.graphicLoader);
    this.graphicLoader = null;
  }

  /**
   * Handle errors from loader.
   * @param {object} Event Error event.
   */
  static handleFileError(e) {
    console.warn(`Error: ${e.title}`);
    console.log(e);
  }

  /**
   * Pushing loaded object to Game.IMAGES if file is image.
   * @param {object} Event Loaded item event.
   */
  static handleFileLoad(e) {
    if (e.item.type === 'image') {
      Game.IMAGES[e.item.id] = e.result;
    }
  }

  /**
   * Shows loading progress.
   */
  handleProgress() {
    const percent = Math.round(this.loader.progress * 100);

    console.log(`Loading ${percent} %`);
    this.textLoader.text = `Loading ${percent} %`;
  }

  /**
   * Fires when loading is complete.
   * Slides up graphic loader and executes callback.
   * @param {object} Callback Callback - resolve loader promise
   */
  handleComplete(cb) {
    Tween.get(this.graphicLoader)
      .to({ y: -config.canvas.height }, 1000, Ease.cubicInOut)
      .call(this.eraseTextLoader)
      .call(cb);
  }

}
