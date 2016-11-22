/* eslint-enable import/no-extraneous-dependencies, import/extensions, import/no-unresolved */

import config from '../config';
import utils from '../modules/utils';
import Preload from './Preload';
import MainMenu from './MainScene';

/**
 * The class representing a player of the game
 */
export default class Player {
  constructor(name) {
    this.position = [];
    this.name = name;
  }

  updatePosition(x, y) {
    console.log(`New position for player ${this.name}: (${x},${y}).`);
    this.position.push([x, y]);
  }
}
