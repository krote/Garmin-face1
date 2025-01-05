using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;
using Toybox.ActivityMonitor;
using Toybox.Graphics;

import Toybox.Lang;

class MoveBar extends WatchUi.Drawable {
    typedef MoveBarParams as {
        :x as Number,
        :y as Number,
        :width as Number,
        :height as Number,
        :separator as Number    
    };

    function initialize(params){
        Drawable.initialize(params);
    }
}
