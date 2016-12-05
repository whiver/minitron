/* eslint-disable import/no-extraneous-dependencies, import/extensions, import/no-unresolved */
import { Bitmap, Shape } from 'EaselJS';
import config from '../config';
import utils from '../modules/utils';
import Game from './Game';
import Player from './Player';
import EndScene from './EndScene';


/* Game constants */
const GRID_MARGIN = 50;
const GRID_STROKE_WIDTH = 3;
const DELAY = document.getElementById('turn-delay').value;

/** Show game view */
export default class MainScene {
  /**
   * Calling init function
   */
  constructor(boardSize = 30, p1X = 1, p1Y = 1, p2X = 10, p2Y = 10, p1AI = 'AI_FOLLOWER', p2AI = 'AI_RANDOM2') {
    this.players = [];
    this.init(boardSize, p1X, p1Y, p2X, p2Y, p1AI, p2AI);
  }

  /**
   * Create mainmenu container with title object
   */
  init(boardSize, p1X, p1Y, p2X, p2Y, p1AI, p2AI) {
    this.ctr = utils.drawCtr();

    this.bg = new Bitmap(Game.IMAGES.mainSceneBg);
    const scale = Math.max(
      config.canvas.width / this.bg.image.width,
      config.canvas.height / this.bg.image.height);
    this.bg.scaleX = this.bg.scaleY = scale;
    this.ctr.addChild(this.bg);

    const startURL = `http://localhost:8000/start?boardSize=${boardSize}&p1X=${p1X}&p1Y=${p1Y}&p2X=${p2X}&p2Y=${p2Y}&p1AI=${p1AI}&p2AI=${p2AI}`;

    // Init the server connection
    utils.request({
      url: startURL,
      method: 'GET',
    }, (err, res) => {
      if (res.statusCode !== 204) window.console.error('Can\'t reach the Prolog server :(');
      else {
        /*
          Should contain:
          size: int
          heads: array, contains each player object
            x: int -> starting at 1
            y: int -> starting at 1
         */
        this.setupBoard(boardSize, boardSize);

        const player1 = new Player(this.cellSize, p1X, p1Y);
        console.log(`Player added: ${player1.getName()}.`);

        this.players.push(player1);
        this.board.addChild(player1);

        const player2 = new Player(this.cellSize, p2X, p2Y);
        console.log(`Player added: ${player2.getName()}.`);

        this.players.push(player2);
        this.board.addChild(player2);
      }

      Game.STAGE.addChild(this.ctr);
      this.fetchNextMove();
    });
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
    grid.alpha = 0.2;
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

  /**
   * Fetch from the server the next move of each player
   */
  fetchNextMove() {
    utils.request({
      url: 'http://localhost:8000/playOnce',
      method: 'GET',
      json: true,
      responseType: 'json',
    }, (err, res, response) => {
      if (response == null) window.console.error('Can\'t reach the Prolog server :(');
      else if (response.state === 'CONTINUE') {
        this.players[0].updatePosition(response.p1X, response.p1Y);
        this.players[1].updatePosition(response.p2X, response.p2Y);

        // Fetch the next move after a few moment
        window.setTimeout(this.fetchNextMove.bind(this), DELAY);
      } else {
        console.log(`Game ended: ${response.state}`);
        return new EndScene(
          response.state === 'DRAW'
          ? null
          : this.players[response.state === 'WINNER1' ? 0 : 1]
        );
      }

      return true;
    });
  }

}
