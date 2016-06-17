/*
 * Enum that defines state in the tower comparison game. Used to determine current game state.
 *
 *    P LACING_TOWERS: Prompt for placing towers. Can proceed to FALL_PREDICTION when the correct towers are placed and continue is pressed.
 *                     Can be kicked back here if shake is clicked in FALL_PREDICTION but the correct towers are no longer placed. Returns to
 *                     this state when during RESET after all the towers are cleared off the table.
 *    FALL_PREDICTION: The user predicts which tower will fall. After guessing, the user clicks the shake button to enter SHAKING(and begin 
 *                     shaking the table, or gets kicked back to PLACING_TOWERS if the correct towers are no longer placed.
 *            SHAKING: When the shake button is pressed is pressed, the heights of the 2 towers are recorded and the table begins shaking. 
 *                     Shaking will stop when a tower falls(height drops by some amount, if a timeout is reached(5 seconds), or if the current 
 *                     data recieved from the kinect no longer makes sense(e.g. both towers disappeared, there are extra towers in the scene( 
 *  REASON_PREDICTION: Make a guess as to why the tower fell. After a guess is made(by hitting one of the 4 prediction buttons), the state changes
 *                     to REASON. 
 *             REASON: Once a reason for the towers falling has been guessed, we show the correct anwer. The continue button is pressed to move on
 *                     to RESET.
 *              RESET: The user is prompted to clear the old towers off the table. Once the all tower are removed from the scene, transition to
 *                     PLACING_TOWERS or TRANSITION if we have performed enough cycles of the game
 * UNEXPECTED_OUTCOME: We transition to this state if the wrong tower falls during SHAKING or if we can't figure out what happened when the towers
 *                     shook(Sometimes a guess is made or we assume the correct tower fell). Otherwise transition to UNEXPECTED_OUTCOME, tell the
 *                     player that "this does not usually happen" and repeat for this tower pair.
 *         TRANSITION: The Transition screen is showed to see if the player would like to test his/her own tower. This screen appears every X cycles
 *                   : of the main game that is played(currently X = 4)
 */
 
public enum MainGameState{
  PLACING_TOWERS, FALL_PREDICTION, SHAKING, REASON_PREDICTION, REASON, RESET, UNEXPECTED_OUTCOME, TRANSITION;
}
