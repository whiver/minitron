/* eslint-disable import/no-extraneous-dependencies, import/extensions, import/no-unresolved */
import { Shape, Container, Shadow } from 'EaselJS';
import utils from '../modules/utils';

const PLAYER_COLORS = utils.shuffle([
  '#a1ee57',
  '#FFFC00',
  '#FF0D15',
  '#1DE2F5',
]);

const PLAYER_NAMES = utils.shuffle([
  'Jarvis',
  'xXxRaptorxXx',
  'BigBlue',
  'Unicoooorn',
  'DarkRebellion',
  'W0oOlf',
]);

let currentId = 0;

/**
 * The class representing a player of the game
 * @param name  Name of the player
 * @param size  Size of a cell in the grid
 * @param x     X position of the first cell where to put the player
 * @param y     Y position of the first cell where to put the player
 */
export default class Player extends Container {
  constructor(size, x, y) {
    super();
    this.id = currentId++;
    this.cellSize = size;

    this.init(x, y);
  }

  /**
   * Init the player instance
   * @param x     X position of the first cell where to put the player
   * @param y     Y position of the first cell where to put the player
   */
  init(x, y) {
    this.playerShape = new Shape();
    this.addChild(this.playerShape);

    // Shadow effect
    this.playerShape.shadow = new Shadow(PLAYER_COLORS[this.id], 0, 0, this.cellSize / 3);

    this.updatePosition(x, y);
  }

  /**
   * Update the player's position
   * @param x The X cell position (starting at 0)
   * @param y The Y cell position (starting at 0)
   */
  updatePosition(x, y) {
    console.log(`New position for player ${this.getName()}: (${x},${y}).`);

    // Draw the new position
    this.playerShape.graphics.beginStroke(PLAYER_COLORS[this.id]);
    this.playerShape.graphics.setStrokeStyle(this.cellSize);
    this.playerShape.graphics.rect(this.cellSize * (x - 0.5), this.cellSize * (y - 0.5), 1, 1);
  }

  getColor() {
    return PLAYER_COLORS[this.id];
  }

  getName() {
    return PLAYER_NAMES[this.id];
  }
}

Player.PLAYER_NAMES = PLAYER_NAMES;
Player.PLAYER_COLORS = PLAYER_COLORS;
