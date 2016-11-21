/* eslint-disable import/no-extraneous-dependencies, import/extensions, import/no-unresolved */
import { Bitmap } from 'EaselJS';

import config from '../config';
import utils from '../modules/utils';
import Game from './Game';

/** MainMenu showing game menu */
export default class MainScene {

  /**
   * Calling init function
   */
  constructor() {
    this.init();
  }

  /**
   * Create mainmenu container with title object
   */
  init() {
    this.ctr = utils.drawCtr();

    this.bg = new Bitmap(Game.IMAGES.mainSceneBg);
    const scale = Math.max(
      config.canvas.width / this.bg.image.width,
      config.canvas.height / this.bg.image.height);
    this.bg.scaleX = this.bg.scaleY = scale;

    this.title = utils.drawText('Coucou mapoule !', '50px Ubuntu Mono');
    utils.centerObjectByDims(this.title, config.canvas.width, config.canvas.height);

    this.ctr.addChild(this.bg, this.title);
    Game.STAGE.addChild(this.ctr);
  }

}
