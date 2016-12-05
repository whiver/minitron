/* eslint-disable import/no-extraneous-dependencies, import/extensions, import/no-unresolved */
import * as utils from '../modules/utils';
import config from '../config';
import Game from './Game';

const SHAPE_HEIGHT = 400;

/** Show victory view */
export default class EndScene {
  /**
   * Calling init function
   * @param {Player} winner The player who won the game
   */
  constructor(winner) {
    this.winner = winner;
    this.init();
  }

  /**
   * Create mainmenu container with title object
   */
  init() {
    this.ctr = utils.drawCtr(0, (config.canvas.height - SHAPE_HEIGHT) / 2);

    if (this.winner) {
      const shp = utils.drawShp(0, 0, config.canvas.width, SHAPE_HEIGHT, 'black'),
        winnerName = utils.drawText(this.winner.getName(), '110px Ubuntu', this.winner.getColor()),
        text = utils.drawText('won the game!', '40px Ubuntu', 'white');

      this.ctr.addChild(shp, winnerName, text);

      winnerName.y = 50;
      text.y = 300;
      shp.alpha = 0.6;

      utils.centerObjectHorizontal(text, this.ctr);
      utils.centerObjectHorizontal(winnerName, this.ctr);
    } else {
      const shp = utils.drawShp(0, 0, config.canvas.width, SHAPE_HEIGHT, 'black'),
        winnerName = utils.drawText('Draw!', '110px Ubuntu', 'white');

      this.ctr.addChild(shp, winnerName);

      winnerName.textBaseline = 'middle';
      shp.alpha = 0.6;

      utils.centerObject(winnerName, this.ctr);
    }

    Game.STAGE.addChild(this.ctr);
  }
}
