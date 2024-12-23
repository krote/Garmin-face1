using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;
using Toybox.Graphics;

import Toybox.Lang;

enum /* GOAL TYPES */ {
    GOAL_TYPE_BATTERY = -1,
    GOAL_TYPE_CALORIES = -2,
    GOAL_TYPE_OFF = -3,
    GOAL_TYPE_STEPS = 0,
    GOAL_TYPE_FLOORS_CLIMBED,
    GOAL_TYPE_ACTIVE_MINUTES
}

class GoalMeter extends WatchUi.Drawable {
    private var mSide;
    private var mStroke;
    private var mWidth;
    private var mHeight;
    private var mSeparator;
    private var mLayoutSeparator;

    typeof GoalMeterParams as {
        :side as Symbol,
        :stroke as Number,
        :height as Number,
        :separator as Number
    };

    function initialize(params as GoalMeterParams){
        Drawable.initialize(params);

        mSide = params[:side];
        mStroke = params[:stroke];
        mHeight = params[:height];
        mLayoutSeparator = params[:separator];
        onSettingsChanged();
        mWidth = getWidth();
    }
    
    function getWidth(){
        var width;
        var halfScreenWidth;
        var innerRadius;
        return width;
    }
}
