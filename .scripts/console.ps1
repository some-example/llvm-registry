<## 
  FluentConsole Functions
  (C) 2022 Garrett Serack
  License: MIT

  Usage:
    dot source this into your script (. FluentConsole.ps1 )
    
    and then you can use the colon-prefixed functions. 
    You can separate colon-function calls with ';' or '|' or a newline.
    
    : -- writes to the console, no newline
    :: -- writes to the console, with newline

    :<color> -- writes to the console, with foreground color
    :/<backcolor> -- writes to the console, with background color
    :<color>/<backcolor> -- writes to the console, with the foreground and background colors

    :<shortname> -- writes to the console, with a github shortname emoji

  Examples:
    :green this is green
    :green/gray this is green and gray background
    :/darkgray this is just dark gray background
    : this is a tv |:tv
    :purple_circle is a purple circle
    :: this is a line that ends in a newline
    : this next line is like the previous |:: 
    :: hi |:: there
    :green hello |:red world |:: this is a newline

#>
$script:indent= 0
function :() { 
  $cmds = [System.Collections.ArrayList]::new()
  $shh = $cmds.Add( [System.Collections.ArrayList]::new())
  $args |% { 
    if( $cmds[-1].Count -eq 0 ) {
      $shh = $cmds[-1].Add(':');
    }
    if ($_ -match '^:' ) { 
      $shh = $cmds.Add( [System.Collections.ArrayList]::new() )
    }
    if( $_ -match " ") {
      $txt = $_ -replace '''',''''''
      $shh = $cmds[-1].Add("'$txt'")

    } else {
      $shh = $cmds[-1].Add("$_")
    }
  }
  if( $cmds.Count -gt 1 ) {
    $cmds |% { $cmd = $_ -join " " ; iex $cmd }
  } else {
    write-host -nonewline @args 
  }
}
function ::() { write-host @args; write-host -nonewline ("  " * $script:indent) }

function :>() { 
  $script:indent++; 
  write-host -nonewline "  " 
  write-host -nonewline @args
}

function :<() { 
  $script:indent--; 
  if( $script:indent -lt 0 ) { $script:indent = 0 }
  write-host -nonewline ([char]13)
  write-host -nonewline ("  " * $script:indent) 
  write-host -nonewline @args
} 

# generate emoji functions
@{
  "+1"="1f44d";"-1"="1f44e";"100"="1f4af";"1234"="1f522";"1st_place_medal"="1f947";"2nd_place_medal"="1f948";"3rd_place_medal"="1f949";"8ball"="1f3b1";a="1f170";ab="1f18e";abacus="1f9ee";abc="1f524"; 
  abcd="1f521";accept="1f251";accordion="1fa97";adhesive_bandage="1fa79";adult="1f9d1";aerial_tramway="1f6a1";afghanistan="1f1e6 1f1eb";airplane="2708";aland_islands="1f1e6 1f1fd"; 
  alarm_clock="23f0";albania="1f1e6 1f1f1";alembic="2697";algeria="1f1e9 1f1ff";alien="1f47d";ambulance="1f691";american_samoa="1f1e6 1f1f8";amphora="1f3fa";anatomical_heart="1fac0";anchor="2693"; 
  andorra="1f1e6 1f1e9";angel="1f47c";anger="1f4a2";angola="1f1e6 1f1f4";angry="1f620";anguilla="1f1e6 1f1ee";anguished="1f627";ant="1f41c";antarctica="1f1e6 1f1f6";antigua_barbuda="1f1e6 1f1ec";
  apple="1f34e";aquarius="2652";argentina="1f1e6 1f1f7";aries="2648";armenia="1f1e6 1f1f2";arrow_backward="25c0";arrow_double_down="23ec";arrow_double_up="23eb";arrow_down="2b07"; 
  arrow_down_small="1f53d";arrow_forward="25b6";arrow_heading_down="2935";arrow_heading_up="2934";arrow_left="2b05";arrow_lower_left="2199";arrow_lower_right="2198";arrow_right="27a1"; 
  arrow_right_hook="21aa";arrow_up="2b06";arrow_up_down="2195";arrow_up_small="1f53c";arrow_upper_left="2196";arrow_upper_right="2197";arrows_clockwise="1f503";arrows_counterclockwise="1f504"; 
  art="1f3a8";articulated_lorry="1f69b";artificial_satellite="1f6f0";artist="1f9d1 1f3a8";aruba="1f1e6 1f1fc";ascension_island="1f1e6 1f1e8";asterisk="002a 20e3";astonished="1f632"; 
  astronaut="1f9d1 1f680";athletic_shoe="1f45f";atm="1f3e7";atom_symbol="269b";australia="1f1e6 1f1fa";austria="1f1e6 1f1f9";auto_rickshaw="1f6fa";avocado="1f951";axe="1fa93"; 
  azerbaijan="1f1e6 1f1ff";b="1f171";baby="1f476";baby_bottle="1f37c";baby_chick="1f424";baby_symbol="1f6bc";back="1f519";bacon="1f953";badger="1f9a1";badminton="1f3f8";bagel="1f96f"; 
  baggage_claim="1f6c4";baguette_bread="1f956";bahamas="1f1e7 1f1f8";bahrain="1f1e7 1f1ed";balance_scale="2696";bald_man="1f468 1f9b2";bald_woman="1f469 1f9b2";ballet_shoes="1fa70"; 
  balloon="1f388";ballot_box="1f5f3";ballot_box_with_check="2611";bamboo="1f38d";banana="1f34c";bangbang="203c";bangladesh="1f1e7 1f1e9";banjo="1fa95";bank="1f3e6";bar_chart="1f4ca"; 
  barbados="1f1e7 1f1e7";barber="1f488";baseball="26be";basket="1f9fa";basketball="1f3c0";basketball_man="26f9 2642";basketball_woman="26f9 2640";bat="1f987";bath="1f6c0";bathtub="1f6c1"; 
  battery="1f50b";beach_umbrella="1f3d6";bear="1f43b";bearded_person="1f9d4";beaver="1f9ab";bed="1f6cf";bee="1f41d";beer="1f37a";beers="1f37b";beetle="1fab2";beginner="1f530"; 
  belarus="1f1e7 1f1fe";belgium="1f1e7 1f1ea";belize="1f1e7 1f1ff";bell="1f514";bell_pepper="1fad1";bellhop_bell="1f6ce";benin="1f1e7 1f1ef";bento="1f371";bermuda="1f1e7 1f1f2"; 
  beverage_box="1f9c3";bhutan="1f1e7 1f1f9";bicyclist="1f6b4";bike="1f6b2";biking_man="1f6b4 2642";biking_woman="1f6b4 2640";bikini="1f459";billed_cap="1f9e2";biohazard="2623";bird="1f426"; 
  birthday="1f382";bison="1f9ac";black_cat="1f408 2b1b";black_circle="26ab";black_flag="1f3f4";black_heart="1f5a4";black_joker="1f0cf";black_large_square="2b1b";black_medium_small_square="25fe"; 
  black_medium_square="25fc";black_nib="2712";black_small_square="25aa";black_square_button="1f532";blond_haired_man="1f471 2642";blond_haired_person="1f471";blond_haired_woman="1f471 2640"; 
  blonde_woman="1f471 2640";blossom="1f33c";blowfish="1f421";blue_book="1f4d8";blue_car="1f699";blue_heart="1f499";blue_square="1f7e6";blueberries="1fad0";blush="1f60a";boar="1f417"; 
  boat="26f5";bolivia="1f1e7 1f1f4";bomb="1f4a3";bone="1f9b4";book="1f4d6";bookmark="1f516";bookmark_tabs="1f4d1";books="1f4da";boom="1f4a5";boomerang="1fa83";boot="1f462"; 
  bosnia_herzegovina="1f1e7 1f1e6";botswana="1f1e7 1f1fc";bouncing_ball_man="26f9 2642";bouncing_ball_person="26f9";bouncing_ball_woman="26f9 2640";bouquet="1f490";bouvet_island="1f1e7 1f1fb"; 
  bow="1f647";bow_and_arrow="1f3f9";bowing_man="1f647 2642";bowing_woman="1f647 2640";bowl_with_spoon="1f963";bowling="1f3b3";boxing_glove="1f94a";boy="1f466";brain="1f9e0";brazil="1f1e7 1f1f7"; 
  bread="1f35e";breast_feeding="1f931";bricks="1f9f1";bride_with_veil="1f470 2640";bridge_at_night="1f309";briefcase="1f4bc";british_indian_ocean_territory="1f1ee 1f1f4"; 
  british_virgin_islands="1f1fb 1f1ec";broccoli="1f966";broken_heart="1f494";broom="1f9f9";brown_circle="1f7e4";brown_heart="1f90e";brown_square="1f7eb";brunei="1f1e7 1f1f3";bubble_tea="1f9cb"; 
  bucket="1faa3";bug="1f41b";building_construction="1f3d7";bulb="1f4a1";bulgaria="1f1e7 1f1ec";bullettrain_front="1f685";bullettrain_side="1f684";burkina_faso="1f1e7 1f1eb";burrito="1f32f"; 
  burundi="1f1e7 1f1ee";bus="1f68c";business_suit_levitating="1f574";busstop="1f68f";bust_in_silhouette="1f464";busts_in_silhouette="1f465";butter="1f9c8";butterfly="1f98b";cactus="1f335"; 
  cake="1f370";calendar="1f4c6";call_me_hand="1f919";calling="1f4f2";cambodia="1f1f0 1f1ed";camel="1f42b";camera="1f4f7";camera_flash="1f4f8";cameroon="1f1e8 1f1f2";camping="1f3d5"; 
  canada="1f1e8 1f1e6";canary_islands="1f1ee 1f1e8";cancer="264b";candle="1f56f";candy="1f36c";canned_food="1f96b";canoe="1f6f6";cape_verde="1f1e8 1f1fb";capital_abcd="1f520";capricorn="2651"; 
  car="1f697";card_file_box="1f5c3";card_index="1f4c7";card_index_dividers="1f5c2";caribbean_netherlands="1f1e7 1f1f6";carousel_horse="1f3a0";carpentry_saw="1fa9a";carrot="1f955"; 
  cartwheeling="1f938";cat="1f431";cat2="1f408";cayman_islands="1f1f0 1f1fe";cd="1f4bf";central_african_republic="1f1e8 1f1eb";ceuta_melilla="1f1ea 1f1e6";chad="1f1f9 1f1e9";chains="26d3"; 
  chair="1fa91";champagne="1f37e";chart="1f4b9";chart_with_downwards_trend="1f4c9";chart_with_upwards_trend="1f4c8";checkered_flag="1f3c1";cheese="1f9c0";cherries="1f352";cherry_blossom="1f338"; 
  chess_pawn="265f";chestnut="1f330";chicken="1f414";child="1f9d2";children_crossing="1f6b8";chile="1f1e8 1f1f1";chipmunk="1f43f";chocolate_bar="1f36b";chopsticks="1f962"; 
  christmas_island="1f1e8 1f1fd";christmas_tree="1f384";church="26ea";cinema="1f3a6";circus_tent="1f3aa";city_sunrise="1f307";city_sunset="1f306";cityscape="1f3d9";cl="1f191";clamp="1f5dc"; 
  clap="1f44f";clapper="1f3ac";classical_building="1f3db";climbing="1f9d7";climbing_man="1f9d7 2642";climbing_woman="1f9d7 2640";clinking_glasses="1f942";clipboard="1f4cb"; 
  clipperton_island="1f1e8 1f1f5";clock1="1f550";clock10="1f559";clock1030="1f565";clock11="1f55a";clock1130="1f566";clock12="1f55b";clock1230="1f567";clock130="1f55c";clock2="1f551"; 
  clock230="1f55d";clock3="1f552";clock330="1f55e";clock4="1f553";clock430="1f55f";clock5="1f554";clock530="1f560";clock6="1f555";clock630="1f561";clock7="1f556";clock730="1f562"; 
  clock8="1f557";clock830="1f563";clock9="1f558";clock930="1f564";closed_book="1f4d5";closed_lock_with_key="1f510";closed_umbrella="1f302";cloud="2601";cloud_with_lightning="1f329"; 
  cloud_with_lightning_and_rain="26c8";cloud_with_rain="1f327";cloud_with_snow="1f328";clown_face="1f921";clubs="2663";cn="1f1e8 1f1f3";coat="1f9e5";cockroach="1fab3";cocktail="1f378"; 
  coconut="1f965";cocos_islands="1f1e8 1f1e8";coffee="2615";coffin="26b0";coin="1fa99";cold_face="1f976";cold_sweat="1f630";collision="1f4a5";colombia="1f1e8 1f1f4";comet="2604"; 
  comoros="1f1f0 1f1f2";compass="1f9ed";computer="1f4bb";computer_mouse="1f5b1";confetti_ball="1f38a";confounded="1f616";confused="1f615";congo_brazzaville="1f1e8 1f1ec";congo_kinshasa="1f1e8 1f1e9";
  congratulations="3297";construction="1f6a7";construction_worker="1f477";construction_worker_man="1f477 2642";construction_worker_woman="1f477 2640";control_knobs="1f39b";convenience_store="1f3ea"; 
  cook="1f9d1 1f373";cook_islands="1f1e8 1f1f0";cookie="1f36a";cool="1f192";cop="1f46e";copyright="00a9";corn="1f33d";costa_rica="1f1e8 1f1f7";cote_divoire="1f1e8 1f1ee";couch_and_lamp="1f6cb"; 
  couple="1f46b";couple_with_heart="1f491";couple_with_heart_man_man="1f468 2764 1f468";couple_with_heart_woman_man="1f469 2764 1f468";couple_with_heart_woman_woman="1f469 2764 1f469";couplekiss="1f48f"; 
  couplekiss_man_man="1f468 2764 1f48b 1f468";couplekiss_man_woman="1f469 2764 1f48b 1f468";couplekiss_woman_woman="1f469 2764 1f48b 1f469";cow="1f42e";cow2="1f404";cowboy_hat_face="1f920";crab="1f980"; 
  crayon="1f58d";credit_card="1f4b3";crescent_moon="1f319";cricket="1f997";cricket_game="1f3cf";croatia="1f1ed 1f1f7";crocodile="1f40a";croissant="1f950";crossed_fingers="1f91e"; 
  crossed_flags="1f38c";crossed_swords="2694";crown="1f451";cry="1f622";crying_cat_face="1f63f";crystal_ball="1f52e";cuba="1f1e8 1f1fa";cucumber="1f952";cup_with_straw="1f964";cupcake="1f9c1"; 
  cupid="1f498";curacao="1f1e8 1f1fc";curling_stone="1f94c";curly_haired_man="1f468 1f9b1";curly_haired_woman="1f469 1f9b1";curly_loop="27b0";currency_exchange="1f4b1";curry="1f35b"; 
  cursing_face="1f92c";custard="1f36e";customs="1f6c3";cut_of_meat="1f969";cyclone="1f300";cyprus="1f1e8 1f1fe";czech_republic="1f1e8 1f1ff";dagger="1f5e1";dancer="1f483";dancers="1f46f"; 
  dancing_men="1f46f 2642";dancing_women="1f46f 2640";dango="1f361";dark_sunglasses="1f576";dart="1f3af";dash="1f4a8";date="1f4c5";de="1f1e9 1f1ea";deaf_man="1f9cf 2642";deaf_person="1f9cf"; 
  deaf_woman="1f9cf 2640";deciduous_tree="1f333";deer="1f98c";denmark="1f1e9 1f1f0";department_store="1f3ec";derelict_house="1f3da";desert="1f3dc";desert_island="1f3dd";desktop_computer="1f5a5"; 
  detective="1f575";diamond_shape_with_a_dot_inside="1f4a0";diamonds="2666";diego_garcia="1f1e9 1f1ec";disappointed="1f61e";disappointed_relieved="1f625";disguised_face="1f978";diving_mask="1f93f"; 
  diya_lamp="1fa94";dizzy="1f4ab";dizzy_face="1f635";djibouti="1f1e9 1f1ef";dna="1f9ec";do_not_litter="1f6af";dodo="1f9a4";dog="1f436";dog2="1f415";dollar="1f4b5";dolls="1f38e"; 
  dolphin="1f42c";dominica="1f1e9 1f1f2";dominican_republic="1f1e9 1f1f4";door="1f6aa";doughnut="1f369";dove="1f54a";dragon="1f409";dragon_face="1f432";dress="1f457";dromedary_camel="1f42a"; 
  drooling_face="1f924";drop_of_blood="1fa78";droplet="1f4a7";drum="1f941";duck="1f986";dumpling="1f95f";dvd="1f4c0";"e-mail"="1f4e7";eagle="1f985";ear="1f442";ear_of_rice="1f33e"; 
  ear_with_hearing_aid="1f9bb";earth_africa="1f30d";earth_americas="1f30e";earth_asia="1f30f";ecuador="1f1ea 1f1e8";egg="1f95a";eggplant="1f346";egypt="1f1ea 1f1ec";eight="0038 20e3"; 
  eight_pointed_black_star="2734";eight_spoked_asterisk="2733";eject_button="23cf";el_salvador="1f1f8 1f1fb";electric_plug="1f50c";elephant="1f418";elevator="1f6d7";elf="1f9dd";elf_man="1f9dd 2642";
  elf_woman="1f9dd 2640";email="1f4e7";end="1f51a";england="1f3f4 e0067 e0062 e0065 e006e e0067 e007f";envelope="2709";envelope_with_arrow="1f4e9";equatorial_guinea="1f1ec 1f1f6";eritrea="1f1ea 1f1f7";
  es="1f1ea 1f1f8";estonia="1f1ea 1f1ea";ethiopia="1f1ea 1f1f9";eu="1f1ea 1f1fa";euro="1f4b6";european_castle="1f3f0";european_post_office="1f3e4";european_union="1f1ea 1f1fa"; 
  evergreen_tree="1f332";exclamation="2757";exploding_head="1f92f";expressionless="1f611";eye="1f441";eye_speech_bubble="1f441 1f5e8";eyeglasses="1f453";eyes="1f440";face_exhaling="1f62e 1f4a8";
  face_in_clouds="1f636 1f32b";face_with_head_bandage="1f915";face_with_spiral_eyes="1f635 1f4ab";face_with_thermometer="1f912";facepalm="1f926";facepunch="1f44a";factory="1f3ed"; 
  factory_worker="1f9d1 1f3ed";fairy="1f9da";fairy_man="1f9da 2642";fairy_woman="1f9da 2640";falafel="1f9c6";falkland_islands="1f1eb 1f1f0";fallen_leaf="1f342";family="1f46a"; 
  family_man_boy="1f468 1f466";family_man_boy_boy="1f468 1f466 1f466";family_man_girl="1f468 1f467";family_man_girl_boy="1f468 1f467 1f466";family_man_girl_girl="1f468 1f467 1f467"; 
  family_man_man_boy="1f468 1f468 1f466";family_man_man_boy_boy="1f468 1f468 1f466 1f466";family_man_man_girl="1f468 1f468 1f467";family_man_man_girl_boy="1f468 1f468 1f467 1f466"; 
  family_man_man_girl_girl="1f468 1f468 1f467 1f467";family_man_woman_boy="1f468 1f469 1f466";family_man_woman_boy_boy="1f468 1f469 1f466 1f466";family_man_woman_girl="1f468 1f469 1f467"; 
  family_man_woman_girl_boy="1f468 1f469 1f467 1f466";family_man_woman_girl_girl="1f468 1f469 1f467 1f467";family_woman_boy="1f469 1f466";family_woman_boy_boy="1f469 1f466 1f466"; 
  family_woman_girl="1f469 1f467";family_woman_girl_boy="1f469 1f467 1f466";family_woman_girl_girl="1f469 1f467 1f467";family_woman_woman_boy="1f469 1f469 1f466"; 
  family_woman_woman_boy_boy="1f469 1f469 1f466 1f466";family_woman_woman_girl="1f469 1f469 1f467";family_woman_woman_girl_boy="1f469 1f469 1f467 1f466";family_woman_woman_girl_girl="1f469 1f469 1f467 1f467";
  farmer="1f9d1 1f33e";faroe_islands="1f1eb 1f1f4";fast_forward="23e9";fax="1f4e0";fearful="1f628";feather="1fab6";feet="1f43e";female_detective="1f575 2640";female_sign="2640"; 
  ferris_wheel="1f3a1";ferry="26f4";field_hockey="1f3d1";fiji="1f1eb 1f1ef";file_cabinet="1f5c4";file_folder="1f4c1";film_projector="1f4fd";film_strip="1f39e";finland="1f1eb 1f1ee"; 
  fire="1f525";fire_engine="1f692";fire_extinguisher="1f9ef";firecracker="1f9e8";firefighter="1f9d1 1f692";fireworks="1f386";first_quarter_moon="1f313";first_quarter_moon_with_face="1f31b";
  fish="1f41f";fish_cake="1f365";fishing_pole_and_fish="1f3a3";fist="270a";fist_left="1f91b";fist_oncoming="1f44a";fist_raised="270a";fist_right="1f91c";five="0035 20e3";flags="1f38f"; 
  flamingo="1f9a9";flashlight="1f526";flat_shoe="1f97f";flatbread="1fad3";fleur_de_lis="269c";flight_arrival="1f6ec";flight_departure="1f6eb";flipper="1f42c";floppy_disk="1f4be"; 
  flower_playing_cards="1f3b4";flushed="1f633";fly="1fab0";flying_disc="1f94f";flying_saucer="1f6f8";fog="1f32b";foggy="1f301";fondue="1fad5";foot="1f9b6";football="1f3c8"; 
  footprints="1f463";fork_and_knife="1f374";fortune_cookie="1f960";fountain="26f2";fountain_pen="1f58b";four="0034 20e3";four_leaf_clover="1f340";fox_face="1f98a";fr="1f1eb 1f1f7"; 
  framed_picture="1f5bc";free="1f193";french_guiana="1f1ec 1f1eb";french_polynesia="1f1f5 1f1eb";french_southern_territories="1f1f9 1f1eb";fried_egg="1f373";fried_shrimp="1f364";fries="1f35f"; 
  frog="1f438";frowning="1f626";frowning_face="2639";frowning_man="1f64d 2642";frowning_person="1f64d";frowning_woman="1f64d 2640";fu="1f595";fuelpump="26fd";full_moon="1f315"; 
  full_moon_with_face="1f31d";funeral_urn="26b1";gabon="1f1ec 1f1e6";gambia="1f1ec 1f1f2";game_die="1f3b2";garlic="1f9c4";gb="1f1ec 1f1e7";gear="2699";gem="1f48e";gemini="264a"; 
  genie="1f9de";genie_man="1f9de 2642";genie_woman="1f9de 2640";georgia="1f1ec 1f1ea";ghana="1f1ec 1f1ed";ghost="1f47b";gibraltar="1f1ec 1f1ee";gift="1f381";gift_heart="1f49d"; 
  giraffe="1f992";girl="1f467";globe_with_meridians="1f310";gloves="1f9e4";goal_net="1f945";goat="1f410";goggles="1f97d";golf="26f3";golfing="1f3cc";golfing_man="1f3cc 2642"; 
  golfing_woman="1f3cc 2640";gorilla="1f98d";grapes="1f347";greece="1f1ec 1f1f7";green_apple="1f34f";green_book="1f4d7";green_circle="1f7e2";green_heart="1f49a";green_salad="1f957"; 
  green_square="1f7e9";greenland="1f1ec 1f1f1";grenada="1f1ec 1f1e9";grey_exclamation="2755";grey_question="2754";grimacing="1f62c";grin="1f601";grinning="1f600";guadeloupe="1f1ec 1f1f5"; 
  guam="1f1ec 1f1fa";guard="1f482";guardsman="1f482 2642";guardswoman="1f482 2640";guatemala="1f1ec 1f1f9";guernsey="1f1ec 1f1ec";guide_dog="1f9ae";guinea="1f1ec 1f1f3"; 
  guinea_bissau="1f1ec 1f1fc";guitar="1f3b8";gun="1f52b";guyana="1f1ec 1f1fe";haircut="1f487";haircut_man="1f487 2642";haircut_woman="1f487 2640";haiti="1f1ed 1f1f9";hamburger="1f354"; 
  hammer="1f528";hammer_and_pick="2692";hammer_and_wrench="1f6e0";hamster="1f439";hand="270b";hand_over_mouth="1f92d";handbag="1f45c";handball_person="1f93e";handshake="1f91d";
  hankey="1f4a9";hash="0023 20e3";hatched_chick="1f425";hatching_chick="1f423";headphones="1f3a7";headstone="1faa6";health_worker="1f9d1 2695";hear_no_evil="1f649"; 
  heard_mcdonald_islands="1f1ed 1f1f2";heart="2764";heart_decoration="1f49f";heart_eyes="1f60d";heart_eyes_cat="1f63b";heart_on_fire="2764 1f525";heartbeat="1f493";heartpulse="1f497"; 
  hearts="2665";heavy_check_mark="2714";heavy_division_sign="2797";heavy_dollar_sign="1f4b2";heavy_exclamation_mark="2757";heavy_heart_exclamation="2763";heavy_minus_sign="2796"; 
  heavy_multiplication_x="2716";heavy_plus_sign="2795";hedgehog="1f994";helicopter="1f681";herb="1f33f";hibiscus="1f33a";high_brightness="1f506";high_heel="1f460";hiking_boot="1f97e"; 
  hindu_temple="1f6d5";hippopotamus="1f99b";hocho="1f52a";hole="1f573";honduras="1f1ed 1f1f3";honey_pot="1f36f";honeybee="1f41d";hong_kong="1f1ed 1f1f0";hook="1fa9d";horse="1f434"; 
  horse_racing="1f3c7";hospital="1f3e5";hot_face="1f975";hot_pepper="1f336";hotdog="1f32d";hotel="1f3e8";hotsprings="2668";hourglass="231b";hourglass_flowing_sand="23f3";house="1f3e0"; 
  house_with_garden="1f3e1";houses="1f3d8";hugs="1f917";hungary="1f1ed 1f1fa";hushed="1f62f";hut="1f6d6";ice_cream="1f368";ice_cube="1f9ca";ice_hockey="1f3d2";ice_skate="26f8"; 
  icecream="1f366";iceland="1f1ee 1f1f8";id="1f194";ideograph_advantage="1f250";imp="1f47f";inbox_tray="1f4e5";incoming_envelope="1f4e8";india="1f1ee 1f1f3";indonesia="1f1ee 1f1e9"; 
  infinity="267e";information_desk_person="1f481";information_source="2139";innocent="1f607";interrobang="2049";iphone="1f4f1";iran="1f1ee 1f1f7";iraq="1f1ee 1f1f6";ireland="1f1ee 1f1ea";
  isle_of_man="1f1ee 1f1f2";israel="1f1ee 1f1f1";it="1f1ee 1f1f9";izakaya_lantern="1f3ee";jack_o_lantern="1f383";jamaica="1f1ef 1f1f2";japan="1f5fe";japanese_castle="1f3ef"; 
  japanese_goblin="1f47a";japanese_ogre="1f479";jeans="1f456";jersey="1f1ef 1f1ea";jigsaw="1f9e9";jordan="1f1ef 1f1f4";joy="1f602";joy_cat="1f639";joystick="1f579";jp="1f1ef 1f1f5"; 
  judge="1f9d1 2696";juggling_person="1f939";kaaba="1f54b";kangaroo="1f998";kazakhstan="1f1f0 1f1ff";kenya="1f1f0 1f1ea";key="1f511";keyboard="2328";keycap_ten="1f51f";kick_scooter="1f6f4";
  kimono="1f458";kiribati="1f1f0 1f1ee";kiss="1f48b";kissing="1f617";kissing_cat="1f63d";kissing_closed_eyes="1f61a";kissing_heart="1f618";kissing_smiling_eyes="1f619";kite="1fa81"; 
  kiwi_fruit="1f95d";kneeling_man="1f9ce 2642";kneeling_person="1f9ce";kneeling_woman="1f9ce 2640";knife="1f52a";knot="1faa2";koala="1f428";koko="1f201";kosovo="1f1fd 1f1f0"; 
  kr="1f1f0 1f1f7";kuwait="1f1f0 1f1fc";kyrgyzstan="1f1f0 1f1ec";lab_coat="1f97c";label="1f3f7";lacrosse="1f94d";ladder="1fa9c";lady_beetle="1f41e";lantern="1f3ee";laos="1f1f1 1f1e6"; 
  large_blue_circle="1f535";large_blue_diamond="1f537";large_orange_diamond="1f536";last_quarter_moon="1f317";last_quarter_moon_with_face="1f31c";latin_cross="271d";latvia="1f1f1 1f1fb"; 
  laughing="1f606";leafy_green="1f96c";leaves="1f343";lebanon="1f1f1 1f1e7";ledger="1f4d2";left_luggage="1f6c5";left_right_arrow="2194";left_speech_bubble="1f5e8"; 
  leftwards_arrow_with_hook="21a9";leg="1f9b5";lemon="1f34b";leo="264c";leopard="1f406";lesotho="1f1f1 1f1f8";level_slider="1f39a";liberia="1f1f1 1f1f7";libra="264e";libya="1f1f1 1f1fe"; 
  liechtenstein="1f1f1 1f1ee";light_rail="1f688";link="1f517";lion="1f981";lips="1f444";lipstick="1f484";lithuania="1f1f1 1f1f9";lizard="1f98e";llama="1f999";lobster="1f99e"; 
  lock="1f512";lock_with_ink_pen="1f50f";lollipop="1f36d";long_drum="1fa98";loop="27bf";lotion_bottle="1f9f4";lotus_position="1f9d8";lotus_position_man="1f9d8 2642"; 
  lotus_position_woman="1f9d8 2640";loud_sound="1f50a";loudspeaker="1f4e2";love_hotel="1f3e9";love_letter="1f48c";love_you_gesture="1f91f";low_brightness="1f505";luggage="1f9f3"; 
  lungs="1fac1";luxembourg="1f1f1 1f1fa";lying_face="1f925";m="24c2";macau="1f1f2 1f1f4";macedonia="1f1f2 1f1f0";madagascar="1f1f2 1f1ec";mag="1f50d";mag_right="1f50e"; 
  mage="1f9d9";mage_man="1f9d9 2642";mage_woman="1f9d9 2640";magic_wand="1fa84";magnet="1f9f2";mahjong="1f004";mailbox="1f4eb";mailbox_closed="1f4ea";mailbox_with_mail="1f4ec"; 
  mailbox_with_no_mail="1f4ed";malawi="1f1f2 1f1fc";malaysia="1f1f2 1f1fe";maldives="1f1f2 1f1fb";male_detective="1f575 2642";male_sign="2642";mali="1f1f2 1f1f1";malta="1f1f2 1f1f9"; 
  mammoth="1f9a3";man="1f468";man_artist="1f468 1f3a8";man_astronaut="1f468 1f680";man_beard="1f9d4 2642";man_cartwheeling="1f938 2642";man_cook="1f468 1f373";man_dancing="1f57a"; 
  man_facepalming="1f926 2642";man_factory_worker="1f468 1f3ed";man_farmer="1f468 1f33e";man_feeding_baby="1f468 1f37c";man_firefighter="1f468 1f692";man_health_worker="1f468 2695"; 
  man_in_manual_wheelchair="1f468 1f9bd";man_in_motorized_wheelchair="1f468 1f9bc";man_in_tuxedo="1f935 2642";man_judge="1f468 2696";man_juggling="1f939 2642";man_mechanic="1f468 1f527"; 
  man_office_worker="1f468 1f4bc";man_pilot="1f468 2708";man_playing_handball="1f93e 2642";man_playing_water_polo="1f93d 2642";man_scientist="1f468 1f52c";man_shrugging="1f937 2642"; 
  man_singer="1f468 1f3a4";man_student="1f468 1f393";man_teacher="1f468 1f3eb";man_technologist="1f468 1f4bb";man_with_gua_pi_mao="1f472";man_with_probing_cane="1f468 1f9af"; 
  man_with_turban="1f473 2642";man_with_veil="1f470 2642";mandarin="1f34a";mango="1f96d";mans_shoe="1f45e";mantelpiece_clock="1f570";manual_wheelchair="1f9bd";maple_leaf="1f341"; 
  marshall_islands="1f1f2 1f1ed";martial_arts_uniform="1f94b";martinique="1f1f2 1f1f6";mask="1f637";massage="1f486";massage_man="1f486 2642";massage_woman="1f486 2640";mate="1f9c9"; 
  mauritania="1f1f2 1f1f7";mauritius="1f1f2 1f1fa";mayotte="1f1fe 1f1f9";meat_on_bone="1f356";mechanic="1f9d1 1f527";mechanical_arm="1f9be";mechanical_leg="1f9bf";medal_military="1f396"; 
  medal_sports="1f3c5";medical_symbol="2695";mega="1f4e3";melon="1f348";memo="1f4dd";men_wrestling="1f93c 2642";mending_heart="2764 1fa79";menorah="1f54e";mens="1f6b9"; 
  mermaid="1f9dc 2640";merman="1f9dc 2642";merperson="1f9dc";metal="1f918";metro="1f687";mexico="1f1f2 1f1fd";microbe="1f9a0";micronesia="1f1eb 1f1f2";microphone="1f3a4"; 
  microscope="1f52c";middle_finger="1f595";military_helmet="1fa96";milk_glass="1f95b";milky_way="1f30c";minibus="1f690";minidisc="1f4bd";mirror="1fa9e";mobile_phone_off="1f4f4"; 
  moldova="1f1f2 1f1e9";monaco="1f1f2 1f1e8";money_mouth_face="1f911";money_with_wings="1f4b8";moneybag="1f4b0";mongolia="1f1f2 1f1f3";monkey="1f412";monkey_face="1f435"; 
  monocle_face="1f9d0";monorail="1f69d";montenegro="1f1f2 1f1ea";montserrat="1f1f2 1f1f8";moon="1f314";moon_cake="1f96e";morocco="1f1f2 1f1e6";mortar_board="1f393";mosque="1f54c"; 
  mosquito="1f99f";motor_boat="1f6e5";motor_scooter="1f6f5";motorcycle="1f3cd";motorized_wheelchair="1f9bc";motorway="1f6e3";mount_fuji="1f5fb";mountain="26f0";mountain_bicyclist="1f6b5";
  mountain_biking_man="1f6b5 2642";mountain_biking_woman="1f6b5 2640";mountain_cableway="1f6a0";mountain_railway="1f69e";mountain_snow="1f3d4";mouse="1f42d";mouse2="1f401";mouse_trap="1faa4";
  movie_camera="1f3a5";moyai="1f5ff";mozambique="1f1f2 1f1ff";mrs_claus="1f936";muscle="1f4aa";mushroom="1f344";musical_keyboard="1f3b9";musical_note="1f3b5";musical_score="1f3bc"; 
  mute="1f507";mx_claus="1f9d1 1f384";myanmar="1f1f2 1f1f2";nail_care="1f485";name_badge="1f4db";namibia="1f1f3 1f1e6";national_park="1f3de";nauru="1f1f3 1f1f7";nauseated_face="1f922"; 
  nazar_amulet="1f9ff";necktie="1f454";negative_squared_cross_mark="274e";nepal="1f1f3 1f1f5";nerd_face="1f913";nesting_dolls="1fa86";netherlands="1f1f3 1f1f1";neutral_face="1f610";new="1f195"; 
  new_caledonia="1f1f3 1f1e8";new_moon="1f311";new_moon_with_face="1f31a";new_zealand="1f1f3 1f1ff";newspaper="1f4f0";newspaper_roll="1f5de";next_track_button="23ed";ng="1f196";ng_man="1f645 2642"; 
  ng_woman="1f645 2640";nicaragua="1f1f3 1f1ee";niger="1f1f3 1f1ea";nigeria="1f1f3 1f1ec";night_with_stars="1f303";nine="0039 20e3";ninja="1f977";niue="1f1f3 1f1fa";no_bell="1f515"; 
  no_bicycles="1f6b3";no_entry="26d4";no_entry_sign="1f6ab";no_good="1f645";no_good_man="1f645 2642";no_good_woman="1f645 2640";no_mobile_phones="1f4f5";no_mouth="1f636";no_pedestrians="1f6b7"; 
  no_smoking="1f6ad";"non-potable_water"="1f6b1";norfolk_island="1f1f3 1f1eb";north_korea="1f1f0 1f1f5";northern_mariana_islands="1f1f2 1f1f5";norway="1f1f3 1f1f4";nose="1f443";notebook="1f4d3"; 
  notebook_with_decorative_cover="1f4d4";notes="1f3b6";nut_and_bolt="1f529";o="2b55";o2="1f17e";ocean="1f30a";octopus="1f419";oden="1f362";office="1f3e2";office_worker="1f9d1 1f4bc"; 
  oil_drum="1f6e2";ok="1f197";ok_hand="1f44c";ok_man="1f646 2642";ok_person="1f646";ok_woman="1f646 2640";old_key="1f5dd";older_adult="1f9d3";older_man="1f474";older_woman="1f475";olive="1fad2"; 
  om="1f549";oman="1f1f4 1f1f2";on="1f51b";oncoming_automobile="1f698";oncoming_bus="1f68d";oncoming_police_car="1f694";oncoming_taxi="1f696";one="0031 20e3";one_piece_swimsuit="1fa71"; 
  onion="1f9c5";open_book="1f4d6";open_file_folder="1f4c2";open_hands="1f450";open_mouth="1f62e";open_umbrella="2602";ophiuchus="26ce";orange="1f34a";orange_book="1f4d9";orange_circle="1f7e0"; 
  orange_heart="1f9e1";orange_square="1f7e7";orangutan="1f9a7";orthodox_cross="2626";otter="1f9a6";outbox_tray="1f4e4";owl="1f989";ox="1f402";oyster="1f9aa";package="1f4e6"; 
  page_facing_up="1f4c4";page_with_curl="1f4c3";pager="1f4df";paintbrush="1f58c";pakistan="1f1f5 1f1f0";palau="1f1f5 1f1fc";palestinian_territories="1f1f5 1f1f8";palm_tree="1f334"; 
  palms_up_together="1f932";panama="1f1f5 1f1e6";pancakes="1f95e";panda_face="1f43c";paperclip="1f4ce";paperclips="1f587";papua_new_guinea="1f1f5 1f1ec";parachute="1fa82";paraguay="1f1f5 1f1fe"; 
  parasol_on_ground="26f1";parking="1f17f";parrot="1f99c";part_alternation_mark="303d";partly_sunny="26c5";partying_face="1f973";passenger_ship="1f6f3";passport_control="1f6c2";pause_button="23f8"; 
  paw_prints="1f43e";peace_symbol="262e";peach="1f351";peacock="1f99a";peanuts="1f95c";pear="1f350";pen="1f58a";pencil="1f4dd";pencil2="270f";penguin="1f427";pensive="1f614"; 
  people_holding_hands="1f9d1 1f91d 1f9d1";people_hugging="1fac2";performing_arts="1f3ad";persevere="1f623";person_bald="1f9d1 1f9b2";person_curly_hair="1f9d1 1f9b1";person_feeding_baby="1f9d1 1f37c"; 
  person_fencing="1f93a";person_in_manual_wheelchair="1f9d1 1f9bd";person_in_motorized_wheelchair="1f9d1 1f9bc";person_in_tuxedo="1f935";person_red_hair="1f9d1 1f9b0";person_white_hair="1f9d1 1f9b3"; 
  person_with_probing_cane="1f9d1 1f9af";person_with_turban="1f473";person_with_veil="1f470";peru="1f1f5 1f1ea";petri_dish="1f9eb";philippines="1f1f5 1f1ed";phone="260e";pick="26cf"; 
  pickup_truck="1f6fb";pie="1f967";pig="1f437";pig2="1f416";pig_nose="1f43d";pill="1f48a";pilot="1f9d1 2708";pinata="1fa85";pinched_fingers="1f90c";pinching_hand="1f90f";pineapple="1f34d"; 
  ping_pong="1f3d3";pirate_flag="1f3f4 2620";pisces="2653";pitcairn_islands="1f1f5 1f1f3";pizza="1f355";placard="1faa7";place_of_worship="1f6d0";plate_with_cutlery="1f37d";play_or_pause_button="23ef";
  pleading_face="1f97a";plunger="1faa0";point_down="1f447";point_left="1f448";point_right="1f449";point_up="261d";point_up_2="1f446";poland="1f1f5 1f1f1";polar_bear="1f43b 2744";police_car="1f693"; 
  police_officer="1f46e";policeman="1f46e 2642";policewoman="1f46e 2640";poodle="1f429";poop="1f4a9";popcorn="1f37f";portugal="1f1f5 1f1f9";post_office="1f3e3";postal_horn="1f4ef";postbox="1f4ee"; 
  potable_water="1f6b0";potato="1f954";potted_plant="1fab4";pouch="1f45d";poultry_leg="1f357";pound="1f4b7";pout="1f621";pouting_cat="1f63e";pouting_face="1f64e";pouting_man="1f64e 2642"; 
  pouting_woman="1f64e 2640";pray="1f64f";prayer_beads="1f4ff";pregnant_woman="1f930";pretzel="1f968";previous_track_button="23ee";prince="1f934";princess="1f478";printer="1f5a8"; 
  probing_cane="1f9af";puerto_rico="1f1f5 1f1f7";punch="1f44a";purple_circle="1f7e3";purple_heart="1f49c";purple_square="1f7ea";purse="1f45b";pushpin="1f4cc";put_litter_in_its_place="1f6ae"; 
  qatar="1f1f6 1f1e6";question="2753";rabbit="1f430";rabbit2="1f407";raccoon="1f99d";racehorse="1f40e";racing_car="1f3ce";radio="1f4fb";radio_button="1f518";radioactive="2622";rage="1f621"; 
  railway_car="1f683";railway_track="1f6e4";rainbow="1f308";rainbow_flag="1f3f3 1f308";raised_back_of_hand="1f91a";raised_eyebrow="1f928";raised_hand="270b";raised_hand_with_fingers_splayed="1f590"; 
  raised_hands="1f64c";raising_hand="1f64b";raising_hand_man="1f64b 2642";raising_hand_woman="1f64b 2640";ram="1f40f";ramen="1f35c";rat="1f400";razor="1fa92";receipt="1f9fe";record_button="23fa"; 
  recycle="267b";red_car="1f697";red_circle="1f534";red_envelope="1f9e7";red_haired_man="1f468 1f9b0";red_haired_woman="1f469 1f9b0";red_square="1f7e5";registered="00ae";relaxed="263a"; 
  relieved="1f60c";reminder_ribbon="1f397";repeat="1f501";repeat_one="1f502";rescue_worker_helmet="26d1";restroom="1f6bb";reunion="1f1f7 1f1ea";revolving_hearts="1f49e";rewind="23ea"; 
  rhinoceros="1f98f";ribbon="1f380";rice="1f35a";rice_ball="1f359";rice_cracker="1f358";rice_scene="1f391";right_anger_bubble="1f5ef";ring="1f48d";ringed_planet="1fa90";robot="1f916"; 
  rock="1faa8";rocket="1f680";rofl="1f923";roll_eyes="1f644";roll_of_paper="1f9fb";roller_coaster="1f3a2";roller_skate="1f6fc";romania="1f1f7 1f1f4";rooster="1f413";rose="1f339"; 
  rosette="1f3f5";rotating_light="1f6a8";round_pushpin="1f4cd";rowboat="1f6a3";rowing_man="1f6a3 2642";rowing_woman="1f6a3 2640";ru="1f1f7 1f1fa";rugby_football="1f3c9";runner="1f3c3"; 
  running="1f3c3";running_man="1f3c3 2642";running_shirt_with_sash="1f3bd";running_woman="1f3c3 2640";rwanda="1f1f7 1f1fc";sa="1f202";safety_pin="1f9f7";safety_vest="1f9ba";sagittarius="2650"; 
  sailboat="26f5";sake="1f376";salt="1f9c2";samoa="1f1fc 1f1f8";san_marino="1f1f8 1f1f2";sandal="1f461";sandwich="1f96a";santa="1f385";sao_tome_principe="1f1f8 1f1f9";sari="1f97b"; 
  sassy_man="1f481 2642";sassy_woman="1f481 2640";satellite="1f4e1";satisfied="1f606";saudi_arabia="1f1f8 1f1e6";sauna_man="1f9d6 2642";sauna_person="1f9d6";sauna_woman="1f9d6 2640";sauropod="1f995";
  saxophone="1f3b7";scarf="1f9e3";school="1f3eb";school_satchel="1f392";scientist="1f9d1 1f52c";scissors="2702";scorpion="1f982";scorpius="264f";scotland="1f3f4 e0067 e0062 e0073 e0063 e0074 e007f"; 
  scream="1f631";scream_cat="1f640";screwdriver="1fa9b";scroll="1f4dc";seal="1f9ad";seat="1f4ba";secret="3299";see_no_evil="1f648";seedling="1f331";selfie="1f933";senegal="1f1f8 1f1f3"; 
  serbia="1f1f7 1f1f8";service_dog="1f415 1f9ba";seven="0037 20e3";sewing_needle="1faa1";seychelles="1f1f8 1f1e8";shallow_pan_of_food="1f958";shamrock="2618";shark="1f988";shaved_ice="1f367"; 
  sheep="1f411";shell="1f41a";shield="1f6e1";shinto_shrine="26e9";ship="1f6a2";shirt="1f455";shit="1f4a9";shoe="1f45e";shopping="1f6cd";shopping_cart="1f6d2";shorts="1fa73";shower="1f6bf"; 
  shrimp="1f990";shrug="1f937";shushing_face="1f92b";sierra_leone="1f1f8 1f1f1";signal_strength="1f4f6";singapore="1f1f8 1f1ec";singer="1f9d1 1f3a4";sint_maarten="1f1f8 1f1fd";six="0036 20e3"; 
  six_pointed_star="1f52f";skateboard="1f6f9";ski="1f3bf";skier="26f7";skull="1f480";skull_and_crossbones="2620";skunk="1f9a8";sled="1f6f7";sleeping="1f634";sleeping_bed="1f6cc";sleepy="1f62a"; 
  slightly_frowning_face="1f641";slightly_smiling_face="1f642";slot_machine="1f3b0";sloth="1f9a5";slovakia="1f1f8 1f1f0";slovenia="1f1f8 1f1ee";small_airplane="1f6e9";small_blue_diamond="1f539"; 
  small_orange_diamond="1f538";small_red_triangle="1f53a";small_red_triangle_down="1f53b";smile="1f604";smile_cat="1f638";smiley="1f603";smiley_cat="1f63a";smiling_face_with_tear="1f972"; 
  smiling_face_with_three_hearts="1f970";smiling_imp="1f608";smirk="1f60f";smirk_cat="1f63c";smoking="1f6ac";snail="1f40c";snake="1f40d";sneezing_face="1f927";snowboarder="1f3c2";snowflake="2744"; 
  snowman="26c4";snowman_with_snow="2603";soap="1f9fc";sob="1f62d";soccer="26bd";socks="1f9e6";softball="1f94e";solomon_islands="1f1f8 1f1e7";somalia="1f1f8 1f1f4";soon="1f51c";sos="1f198"; 
  sound="1f509";south_africa="1f1ff 1f1e6";south_georgia_south_sandwich_islands="1f1ec 1f1f8";south_sudan="1f1f8 1f1f8";space_invader="1f47e";spades="2660";spaghetti="1f35d";sparkle="2747"; 
  sparkler="1f387";sparkles="2728";sparkling_heart="1f496";speak_no_evil="1f64a";speaker="1f508";speaking_head="1f5e3";speech_balloon="1f4ac";speedboat="1f6a4";spider="1f577";spider_web="1f578"; 
  spiral_calendar="1f5d3";spiral_notepad="1f5d2";sponge="1f9fd";spoon="1f944";squid="1f991";sri_lanka="1f1f1 1f1f0";st_barthelemy="1f1e7 1f1f1";st_helena="1f1f8 1f1ed";st_kitts_nevis="1f1f0 1f1f3"; 
  st_lucia="1f1f1 1f1e8";st_martin="1f1f2 1f1eb";st_pierre_miquelon="1f1f5 1f1f2";st_vincent_grenadines="1f1fb 1f1e8";stadium="1f3df";standing_man="1f9cd 2642";standing_person="1f9cd"; 
  standing_woman="1f9cd 2640";star="2b50";star2="1f31f";star_and_crescent="262a";star_of_david="2721";star_struck="1f929";stars="1f320";station="1f689";statue_of_liberty="1f5fd"; 
  steam_locomotive="1f682";stethoscope="1fa7a";stew="1f372";stop_button="23f9";stop_sign="1f6d1";stopwatch="23f1";straight_ruler="1f4cf";strawberry="1f353";stuck_out_tongue="1f61b"; 
  stuck_out_tongue_closed_eyes="1f61d";stuck_out_tongue_winking_eye="1f61c";student="1f9d1 1f393";studio_microphone="1f399";stuffed_flatbread="1f959";sudan="1f1f8 1f1e9";sun_behind_large_cloud="1f325"; 
  sun_behind_rain_cloud="1f326";sun_behind_small_cloud="1f324";sun_with_face="1f31e";sunflower="1f33b";sunglasses="1f60e";sunny="2600";sunrise="1f305";sunrise_over_mountains="1f304";superhero="1f9b8"; 
  superhero_man="1f9b8 2642";superhero_woman="1f9b8 2640";supervillain="1f9b9";supervillain_man="1f9b9 2642";supervillain_woman="1f9b9 2640";surfer="1f3c4";surfing_man="1f3c4 2642"; 
  surfing_woman="1f3c4 2640";suriname="1f1f8 1f1f7";sushi="1f363";suspension_railway="1f69f";svalbard_jan_mayen="1f1f8 1f1ef";swan="1f9a2";swaziland="1f1f8 1f1ff";sweat="1f613";sweat_drops="1f4a6"; 
  sweat_smile="1f605";sweden="1f1f8 1f1ea";sweet_potato="1f360";swim_brief="1fa72";swimmer="1f3ca";swimming_man="1f3ca 2642";swimming_woman="1f3ca 2640";switzerland="1f1e8 1f1ed";symbols="1f523"; 
  synagogue="1f54d";syria="1f1f8 1f1fe";syringe="1f489";"t-rex"="1f996";taco="1f32e";tada="1f389";taiwan="1f1f9 1f1fc";tajikistan="1f1f9 1f1ef";takeout_box="1f961";tamale="1fad4"; 
  tanabata_tree="1f38b";tangerine="1f34a";tanzania="1f1f9 1f1ff";taurus="2649";taxi="1f695";tea="1f375";teacher="1f9d1 1f3eb";teapot="1fad6";technologist="1f9d1 1f4bb";teddy_bear="1f9f8"; 
  telephone="260e";telephone_receiver="1f4de";telescope="1f52d";tennis="1f3be";tent="26fa";test_tube="1f9ea";thailand="1f1f9 1f1ed";thermometer="1f321";thinking="1f914";thong_sandal="1fa74"; 
  thought_balloon="1f4ad";thread="1f9f5";three="0033 20e3";thumbsdown="1f44e";thumbsup="1f44d";ticket="1f3ab";tickets="1f39f";tiger="1f42f";tiger2="1f405";timer_clock="23f2"; 
  timor_leste="1f1f9 1f1f1";tipping_hand_man="1f481 2642";tipping_hand_person="1f481";tipping_hand_woman="1f481 2640";tired_face="1f62b";tm="2122";togo="1f1f9 1f1ec";toilet="1f6bd"; 
  tokelau="1f1f9 1f1f0";tokyo_tower="1f5fc";tomato="1f345";tonga="1f1f9 1f1f4";tongue="1f445";toolbox="1f9f0";tooth="1f9b7";toothbrush="1faa5";top="1f51d";tophat="1f3a9";tornado="1f32a"; 
  tr="1f1f9 1f1f7";trackball="1f5b2";tractor="1f69c";traffic_light="1f6a5";train="1f68b";train2="1f686";tram="1f68a";transgender_flag="1f3f3 26a7";transgender_symbol="26a7"; 
  triangular_flag_on_post="1f6a9";triangular_ruler="1f4d0";trident="1f531";trinidad_tobago="1f1f9 1f1f9";tristan_da_cunha="1f1f9 1f1e6";triumph="1f624";trolleybus="1f68e";trophy="1f3c6"; 
  tropical_drink="1f379";tropical_fish="1f420";truck="1f69a";trumpet="1f3ba";tshirt="1f455";tulip="1f337";tumbler_glass="1f943";tunisia="1f1f9 1f1f3";turkey="1f983";turkmenistan="1f1f9 1f1f2"; 
  turks_caicos_islands="1f1f9 1f1e8";turtle="1f422";tuvalu="1f1f9 1f1fb";tv="1f4fa";twisted_rightwards_arrows="1f500";two="0032 20e3";two_hearts="1f495";two_men_holding_hands="1f46c"; 
  two_women_holding_hands="1f46d";u5272="1f239";u5408="1f234";u55b6="1f23a";u6307="1f22f";u6708="1f237";u6709="1f236";u6e80="1f235";u7121="1f21a";u7533="1f238";u7981="1f232";u7a7a="1f233"; 
  uganda="1f1fa 1f1ec";uk="1f1ec 1f1e7";ukraine="1f1fa 1f1e6";umbrella="2614";unamused="1f612";underage="1f51e";unicorn="1f984";united_arab_emirates="1f1e6 1f1ea";united_nations="1f1fa 1f1f3"; 
  unlock="1f513";up="1f199";upside_down_face="1f643";uruguay="1f1fa 1f1fe";us="1f1fa 1f1f8";us_outlying_islands="1f1fa 1f1f2";us_virgin_islands="1f1fb 1f1ee";uzbekistan="1f1fa 1f1ff";v="270c"; 
  vampire="1f9db";vampire_man="1f9db 2642";vampire_woman="1f9db 2640";vanuatu="1f1fb 1f1fa";vatican_city="1f1fb 1f1e6";venezuela="1f1fb 1f1ea";vertical_traffic_light="1f6a6";vhs="1f4fc"; 
  vibration_mode="1f4f3";video_camera="1f4f9";video_game="1f3ae";vietnam="1f1fb 1f1f3";violin="1f3bb";virgo="264d";volcano="1f30b";volleyball="1f3d0";vomiting_face="1f92e";vs="1f19a"; 
  vulcan_salute="1f596";waffle="1f9c7";wales="1f3f4 e0067 e0062 e0077 e006c e0073 e007f";walking="1f6b6";walking_man="1f6b6 2642";walking_woman="1f6b6 2640";wallis_futuna="1f1fc 1f1eb"; 
  waning_crescent_moon="1f318";waning_gibbous_moon="1f316";warning="26a0";wastebasket="1f5d1";watch="231a";water_buffalo="1f403";water_polo="1f93d";watermelon="1f349";wave="1f44b"; 
  wavy_dash="3030";waxing_crescent_moon="1f312";waxing_gibbous_moon="1f314";wc="1f6be";weary="1f629";wedding="1f492";weight_lifting="1f3cb";weight_lifting_man="1f3cb 2642"; 
  weight_lifting_woman="1f3cb 2640";western_sahara="1f1ea 1f1ed";whale="1f433";whale2="1f40b";wheel_of_dharma="2638";wheelchair="267f";white_check_mark="2705";white_circle="26aa";white_flag="1f3f3"; 
  white_flower="1f4ae";white_haired_man="1f468 1f9b3";white_haired_woman="1f469 1f9b3";white_heart="1f90d";white_large_square="2b1c";white_medium_small_square="25fd";white_medium_square="25fb"; 
  white_small_square="25ab";white_square_button="1f533";wilted_flower="1f940";wind_chime="1f390";wind_face="1f32c";window="1fa9f";wine_glass="1f377";wink="1f609";wolf="1f43a";woman="1f469"; 
  woman_artist="1f469 1f3a8";woman_astronaut="1f469 1f680";woman_beard="1f9d4 2640";woman_cartwheeling="1f938 2640";woman_cook="1f469 1f373";woman_dancing="1f483";woman_facepalming="1f926 2640"; 
  woman_factory_worker="1f469 1f3ed";woman_farmer="1f469 1f33e";woman_feeding_baby="1f469 1f37c";woman_firefighter="1f469 1f692";woman_health_worker="1f469 2695";woman_in_manual_wheelchair="1f469 1f9bd"; 
  woman_in_motorized_wheelchair="1f469 1f9bc";woman_in_tuxedo="1f935 2640";woman_judge="1f469 2696";woman_juggling="1f939 2640";woman_mechanic="1f469 1f527";woman_office_worker="1f469 1f4bc";
  woman_pilot="1f469 2708";woman_playing_handball="1f93e 2640";woman_playing_water_polo="1f93d 2640";woman_scientist="1f469 1f52c";woman_shrugging="1f937 2640";woman_singer="1f469 1f3a4"; 
  woman_student="1f469 1f393";woman_teacher="1f469 1f3eb";woman_technologist="1f469 1f4bb";woman_with_headscarf="1f9d5";woman_with_probing_cane="1f469 1f9af";woman_with_turban="1f473 2640"; 
  woman_with_veil="1f470 2640";womans_clothes="1f45a";womans_hat="1f452";women_wrestling="1f93c 2640";womens="1f6ba";wood="1fab5";woozy_face="1f974";world_map="1f5fa";worm="1fab1";worried="1f61f"; 
  wrench="1f527";wrestling="1f93c";writing_hand="270d";x="274c";yarn="1f9f6";yawning_face="1f971";yellow_circle="1f7e1";yellow_heart="1f49b";yellow_square="1f7e8";yemen="1f1fe 1f1ea"; 
  yen="1f4b4";yin_yang="262f";yo_yo="1fa80";yum="1f60b";zambia="1f1ff 1f1f2";zany_face="1f92a";zap="26a1";zebra="1f993";zero="0030 20e3";zimbabwe="1f1ff 1f1fc";zipper_mouth_face="1f910"; 
  zombie="1f9df";zombie_man="1f9df 2642";zombie_woman="1f9df 2640";zzz="1f4a4"; }.GetEnumerator() |% {
  $e = ($_.value.Split(' ') |% { [System.Char]::ConvertFromUtf32([System.Convert]::ToInt32($_, 16)) }) -join [String]::Empty
  New-Item -Path function: -name "script::$($_.name)" -value ([scriptblock]::Create( ": $e @args"  )) | out-null
}

# generate color functions
[ConsoleColor].GetEnumNames() |% { 
  $c = $_
  New-Item -Path function: -name "script::$c" -value ([scriptblock]::Create( ": -fore $c @args" )) | out-null
  New-Item -Path function: -name "script::/$c" -value ([scriptblock]::Create( ": -back $c @args" )) | out-null
  [ConsoleColor].GetEnumNames() |% { 
    New-Item -Path function: -name "script::$c/$_" -value ([scriptblock]::Create( ": -fore $c -back $_ @args" )) | out-null
  }
}

function :home() {
  : ([char]13)
}

function :note() {
  :grey_exclamation " " |:darkgray @args 
}
