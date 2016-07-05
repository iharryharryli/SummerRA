/*
 * Contains audio object definitions and instantiations. 
 *
 * TODO: REMOVE, and put in setup
 */

import ddf.minim.*;

//AudioPlayer player_clear_table,player_taller,player_thinner, player_weight, player_symm, player,player_startScreen,player_towerFallen, player_towerStanding, player_expl_wrong_weight, player_expl_correct_weight,player_expl_wrong_taller, player_expl_correct_thinner,player_expl_wrong_thinner, player_expl_wrong_symm, player_expl_correct_symm, player_expl_correct_taller, player_hyp_wrong_left, player_hyp_wrong_right, player_hyp_correct_left,player_hyp_correct_right, player_pred_intro, player_pred_left, player_pred_right, player_pred_same, player_place_both, player_place_continue, player_place_wrong_right, player_place_wrong_right_only, player_place_wrong_left_only, player_place_wrong_left, player_place_left, player_place_right, player_place_wrong_both;
AudioPlayer aplayer;
Minim minim;//audio context

public void AudioSetup()
{
  
  minim = new Minim(this);
  aplayer = minim.loadFile("Assets/audio/place_both.wav", 2048);
  /*player_place_both = minim.loadFile("Assets/audio/place_both.wav", 2048);
  player_place_left = minim.loadFile("Assets/audio/place_left.wav", 2048);
  player_place_right = minim.loadFile("Assets/audio/place_right.wav", 2048);
  player_pred_intro = minim.loadFile("Assets/audio/prediction_intro.wav", 2048);
  player_pred_left = minim.loadFile("Assets/audio/prediction_left_first.wav", 2048);
  player_pred_right = minim.loadFile("Assets/audio/prediction_right_first.wav", 2048);
  player_pred_same = minim.loadFile("Assets/audio/prediction_same_first.wav", 2048);
  player_place_continue = minim.loadFile("Assets/audio/place_continue.wav", 2048);
  player_hyp_correct_right = minim.loadFile("Assets/audio/hypothesis_correct_right.wav", 2048);
  player_hyp_correct_left = minim.loadFile("Assets/audio/hypothesis_correct_left.wav", 2048);
  player_hyp_wrong_right = minim.loadFile("Assets/audio/hypothesis_wrong_right.wav", 2048);
  player_hyp_wrong_left = minim.loadFile("Assets/audio/hypothesis_wrong_left.wav", 2048);
  player_expl_wrong_symm = minim.loadFile("Assets/audio/expl_wrong_symm.wav", 2048);
  player_expl_correct_symm = minim.loadFile("Assets/audio/expl_correct_symm.wav", 2048);
  player_expl_wrong_thinner = minim.loadFile("Assets/audio/expl_wrong_thinner.wav", 2048);
  player_expl_correct_thinner = minim.loadFile("Assets/audio/expl_correct_thinner.wav", 2048);
  player_expl_wrong_taller = minim.loadFile("Assets/audio/expl_wrong_taller.wav", 2048);
  player_expl_correct_taller = minim.loadFile("Assets/audio/expl_correct_taller.wav", 2048);
  player_expl_wrong_weight = minim.loadFile("Assets/audio/expl_wrong_weight.wav", 2048);
  player_expl_correct_weight = minim.loadFile("Assets/audio/expl_correct_weight.wav", 2048);
  player_towerFallen = minim.loadFile("Assets/audio/towerFallen_ayo.wav", 2048);
  player_towerStanding = minim.loadFile("Assets/audio/towerStanding_ayo.wav", 2048);
  player_startScreen = minim.loadFile("Assets/audio/startScreen_ayo.wav", 2048);
  player_thinner = minim.loadFile("Assets/audio/startScreen_ayo.wav", 2048);
  player_taller = minim.loadFile("Assets/audio/startScreen_ayo.wav", 2048);
  player_symm = minim.loadFile("Assets/audio/startScreen_ayo.wav", 2048);
  player_weight = minim.loadFile("Assets/audio/startScreen_ayo.wav", 2048);
  player_clear_table = minim.loadFile("Assets/audio/clear_table.wav", 2048);*/
  
  setupAudio();
}
