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

    private var mFillHeight;
    private var mSegments;

    private var mBufferNeedRecreate = true;
    private var mBufferNeedRedraw = true;
    private var mCurrentValue;
    private var mMaxValue;

    typedef GoalMeterParams as {
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

        if(System.getDeviceSettings().screenShape ==  System.SCREEN_SHAPE_RECTANGLE){
            width = mStroke;
        }else{
            halfScreenWidth = System.getDeviceSettings().screenWidth /2;
            innerRadius = halfScreenWidth - mStroke;
            width = halfScreenWidth - Math.sqrt( Math.pow(innerRadius, 2) - Math.pow(mHeight/2,2));
            width = Math.ceil(width).toNumber();    // round up to cover partial pixels
        }
        return width;
    }

    function onSettingsChanged(){
        mBufferNeedRecreate = true;

        var goalMeterStyle = Application.Properties.getValue("GoalMeterStyle");
        if( (goalMeterStyle == 0 /*ALL_SEGMENTS*/ ) || (goalMeterStyle == 3 /*FILLED_SEGMENTS*/)){
            if(mSeparator != mLayoutSeparator){
                mMaxValue = null;
            }
            mSeparator = mLayoutSeparator;
        }else{
            // Force recalculation of mSegments in setValues() if mSeparator is about to change.
            if(mSeparator != 0){
                mMaxValue = null;
            }
            mSeparator = 0;
        }
    }

    function setValues(current, max, isOff){
        if(max != mMaxValue){
            mMaxValue = max;
            mCurrentValue = null;
            mSegments = getSegments();
            mBufferNeedRedraw = true;
        }

        // if curent value changes, recalulate fill height, ahread of draw
        if(current != mCurrentValue){
            mCurrentValue = current;
            mFillHeight = getFillHeight(mSegments);
        }
    }

    // return array of segment heights.
    function getSegments(){

    }

    function getFillHeight(segments as Array<Number>){

    }
}
