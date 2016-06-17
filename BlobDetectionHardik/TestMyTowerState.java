/*
 * Enum that defines state in the test my tower game. Used to determine current game state.
 *
 * PLACING_TOWER: Prompt the user to place a tower. Only display the shake button if one tower is in the scene. Additionally display the contours
 *                when there is only one tower, otherwise show other instructions to either place or remove towers.
 *       SHAKING: The table begins shaking when the Shake button is pressed, and records the height of the only tower on the table, cannot
 *                click or shake if there are no towers, or more than one. Stops shaking when the tower falls, if the timeout is reached(5 seconds)
 *                or if the current kinect tower information does not make logical sense(e.g. no towers, too many towers..)
 *        RESULT: Tells the result of Shaking. "Good job" if the tower stood for 5 seconds(draw contours green) or "Uh oh, your tower fell" if it
 *                fell(draw contours red). Transition to reset if the continue button is pressed or to PLACING_TOWER if the towers are removed from the 
 *                table before the continue button is pressed(and if t least 5 seconds have passed).
 *         RESET: The user is prompted to clear the old towers off the table. Once the all tower are removed from the scene, transition to
 *                PLACING_TOWERS or TRANSITION if we have performed enough cycles of the game
 *    TRANSITION: The Transition screen is showed to see if the player would like to play the learning/comparing towers came.
 *                This screen appears every X cycles.  
 */
public enum TestMyTowerState{
  PLACING_TOWER, SHAKING, RESULT, RESET, CHALLENGE, TRANSITION;
}
