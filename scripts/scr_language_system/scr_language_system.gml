// Initialize Global Language Settings
global.current_language = "EN"; // Supported: "EN", "JP"

/// @function get_localized_text(key)
/// @description Returns translated string based on global.current_language
/// @param {string} _key The key identifier for text
function get_localized_text(_key)
{
    var _text_db = {
        EN: {
            level_complete: "LEVEL COMPLETE!",
            score_text: "SCORE:",
            time_text: "TIME:",
            press_next: "PRESS START / ENTER TO CONTINUE"
        },
        JP: {
            level_complete: "ステージ クリア！",
            score_text: "スコア:",
            time_text: "タイム:",
            press_next: "スタート または エンター で つぎ へ"
        }
    };

    // Fallback logic if language or key is missing
    if (variable_struct_exists(_text_db, global.current_language))
    {
        var _lang_struct = variable_struct_get(_text_db, global.current_language);
        if (variable_struct_exists(_lang_struct, _key))
        {
            return variable_struct_get(_lang_struct, _key);
        }
    }
    
    return "MISSING_TEXT";
}