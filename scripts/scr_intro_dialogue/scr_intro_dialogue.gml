/// @function scr_intro_dialogue()
/// @description Returns the array of intro dialogue structs.
function scr_intro_dialogue() {
    return [
        { 
            name: "Jack", 
            text: "Hey everyone! Welcome to the work-in-progress demo\nof Jack's Mighty Quest!", 
            font: fnt_bitmap, 
            color: c_white, 
            scale: 1, 
            speed: 0.45, 
            hold: 200 
        },
        { 
            name: "Jack", 
            text: "Just a quick heads-up before you jump in:\nthis build is still heavy in active development.", 
            font: fnt_bitmap, 
            color: c_white, 
            scale: 1, 
            speed: 0.45, 
            hold: 220 
        },
        { 
            name: "Jack", 
            text: "That means a lot of stuff you see here - like gameplay\nfeatures, art, and music - might be tweaked,\noverhauled, or removed down the road.", 
            font: fnt_bitmap, 
            color: c_white, 
            scale: 1, 
            speed: 0.45, 
            hold: 260 
        },
        { 
            name: "Jack", 
            text: "Also, please keep this copy to yourself!\nUnauthorized sharing, redistributing, or pirating\nthis early prototype isn't allowed.", 
            font: fnt_bitmap, 
            color: c_white, 
            scale: 1, 
            speed: 0.45, 
            hold: 260 
        },
        { 
            name: "Jack", 
            text: "Thanks for trying out the demo and supporting\nthe project. Hope you have fun checking it out!", 
            font: fnt_bitmap, 
            color: c_white, 
            scale: 1, 
            speed: 0.45, 
            hold: 220 
        }
    ];
}