/* eslint-disable import/no-extraneous-dependencies, import/extensions, import/no-unresolved */
import MainScene from './MainScene';

const GRID_SIZE_FIELD = document.getElementById('board-size');
const PLAYER_1_AI_FIELD = document.getElementById('player-1-config');
const PLAYER_2_AI_FIELD = document.getElementById('player-2-config');
const PLAYER_2_X_FIELD = document.getElementById('player-2-x');
const PLAYER_2_Y_FIELD = document.getElementById('player-2-y');
const PLAYER_1_X_FIELD = document.getElementById('player-1-x');
const PLAYER_1_Y_FIELD = document.getElementById('player-1-y');

/** MainMenu showing game menu */
export default class MenuScene {
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
    this.ctr = document.getElementById('menu');
    this.ctr.style.display = 'block';

    const start = (event) => {
      window.console.log('Game started.');
      this.ctr.style.display = '';
      this.ctr.removeEventListener('submit', start);

      event.stopPropagation();
      event.preventDefault();

      // Get back the game config
      return new MainScene(
        GRID_SIZE_FIELD.value,
        PLAYER_1_X_FIELD.value,
        PLAYER_1_Y_FIELD.value,
        PLAYER_2_X_FIELD.value,
        PLAYER_2_Y_FIELD.value,
        PLAYER_1_AI_FIELD.options[PLAYER_1_AI_FIELD.selectedIndex].value,
        PLAYER_2_AI_FIELD.options[PLAYER_2_AI_FIELD.selectedIndex].value,
      );
    };

    this.ctr.addEventListener('submit', start);
  }
}
