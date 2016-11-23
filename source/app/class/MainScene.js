/* eslint-disable import/no-extraneous-dependencies, import/extensions, import/no-unresolved */
import { Bitmap, Shape } from 'EaselJS';
import config from '../config';
import utils from '../modules/utils';
import Game from './Game';
import Player from './Player';

/* Game constants */
const GRID_MARGIN = 50;
const GRID_STROKE_WIDTH = 5;

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
    this.ctr.addChild(this.bg);

    this.setupBoard(20, 20);
    this.board.addChild(new Player('Jarvis', this.cellSize, 5, 5));

    Game.STAGE.addChild(this.ctr);
  }

  /**
   * Draw the game grid on the scene
   * @param rows  the number of row of the grid
   * @param cols  the number of cols of the grid
   */
  setupBoard(rows, cols) {
    const grid = new Shape();

    // Compute the size of a cell
    this.cellSize =
      (Math.min(config.canvas.width, config.canvas.height) - GRID_MARGIN) / Math.max(rows, cols);

    this.board = utils.drawCtr(
      (config.canvas.width - (cols * this.cellSize)) / 2,
      (config.canvas.height - (rows * this.cellSize)) / 2);
    this.board.width = cols * this.cellSize;
    this.board.height = rows * this.cellSize;

    // Draw the grid
    grid.graphics.setStrokeStyle(GRID_STROKE_WIDTH).beginStroke('#fff');
    grid.alpha = 0.5;
    grid.graphics.rect(0, 0, this.board.width, this.board.height);

    for (let col = 1; col < cols; ++col) {
      grid.graphics.moveTo(this.cellSize * col, 0);
      grid.graphics.lineTo(this.cellSize * col, this.board.height);
    }

    for (let row = 1; row < rows; ++row) {
      grid.graphics.moveTo(0, this.cellSize * row);
      grid.graphics.lineTo(this.board.width, this.cellSize * row);
    }

    this.board.addChild(grid);
    this.ctr.addChild(this.board);
  }

}
