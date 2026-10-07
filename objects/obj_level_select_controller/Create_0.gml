/// @description Initialize the standalone stage select screen.

display_set_gui_size(432, 240);
stages = scr_level_select_data();
stage_count = array_length(stages);
selected_index = 0;
bg_x = 0;
bg_y = 0;
bg_speed_x = 0.75;
bg_speed_y = -0.5;
fade_alpha = 1;
fade_speed = 0.05;
fade_state = 0; // 0 fade in, 1 select, 2 fade out
target_room = rm_title_screen;
gp_axis_x_latched = false;

if (stage_count <= 0) {
    stages = [{ name: "STAGE DATA MISSING", act: "RETURN WITH ESCAPE", room_id: rm_main_menu, unlocked: true }];
    stage_count = 1;
}

play_ui_blip = function(_sound) {
    if (audio_exists(_sound)) {
        var _handle = audio_play_sound(_sound, 1, false);
        var _volume = variable_global_exists("vol_sfx") ? global.vol_sfx / 100 : 1;
        audio_sound_gain(_handle, _volume, 0);
    }
};
