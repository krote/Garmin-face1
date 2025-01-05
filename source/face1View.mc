import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using Toybox.Math;

const INTEGER_FORMAT = "%d";

const SCREEN_MULTIPLIER = (System.getDeviceSettings().screenWidth < 360) ? 1 : 2;
const BATTERY_HEAD_HEIGHT = 4 * SCREEN_MULTIPLIER;
const BATTERY_MARGIN = SCREEN_MULTIPLIER;
var gThemeColor;
var gMonoDarkColor;
var gMonoLightColor;
var gBackgroundColor;
var gMeterBackgroundColor;

var gHoursColor;
var gMinutesColor;

var gNormalFont;
var gIconsFont;

// x, y are co-ordinates of center point.
// widh and height are outer dimensions of battery "body".
function drawBatteryMeter(dc, x, y, width, height){
    dc.setColor(gThemeColor, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(/* BATTERY LINE WIDTH */ 2);
    dc.drawRoundedRectangle(
        x - (width / 2) + /* (BATTERY LINE WIDTH / 2) */ 1,
        y - (height / 2) + /* (BATTERY LINE WIDTH / 2) */ 1,
        width - /* BATTERY LINE WIDTH / 2) */ 1,
        height - /* BATTERY LINE WIDTH / 2) */ 1,
        /* BATTERY CORNER RADIUS / 2) */ 2 * SCREEN_MULTIPLIER
        );

    //head
    dc.fillRectangle(
        x + (width / 2) + BATTERY_MARGIN,
        y - (BATTERY_HEAD_HEIGHT / 2),
        /* BATTERY_HEAD_WIDTH */ 2,
        BATTERY_HEAD_HEIGHT);
    
    // Fill
    var batteryLevel = Math.floor(System.getSystemStats().battery);
    var fillColor;
    if( batteryLevel <= 10) {
        fillColor = Graphics.COLOR_RED;
    }else if(batteryLevel <= 20){
        fillColor = Graphics.COLOR_YELLOW;
    }else{
        fillColor = gThemeColor;
    }
    
    dc.setColor(fillColor, Graphics.COLOR_TRANSPARENT);
    var lineWidthPlusMargin = ( 2 + BATTERY_MARGIN );
    var fillWidth = width - (2 * lineWidthPlusMargin);
    dc.fillRectangle(
        x - (width / 2) + lineWidthPlusMargin,
        y - (height / 2) + lineWidthPlusMargin,
        Math.ceil(fillWidth * (batteryLevel / 100)),
        height - (2 * lineWidthPlusMargin) + (SCREEN_MULTIPLIER - 1));

}

typedef GoalValues as {
    :current as Number,
    :max as Number,
    @:isValid as Boolean
};


class face1View extends WatchUi.WatchFace {
    private var mSettingChangedSinceLastDraw = true;
    private var mIsBurnInProtection = false;

    private var mTime;
    var mDataFields;

    private var mDrawables as Dictionary<Symbol, Drawable> = {};

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        gIconsFont = WatchUi.loadResource(Rez.Fonts.gIconsFont);

        setLayout(Rez.Layouts.WatchFace(dc));
        cacheDrawables();
    }

    function cacheDrawables(){
        mDrawables[:LeftGoalMeter] = View.findDrawableById("LeftGoalMeter");
        mDrawables[:RightGoalMeter] = View.findDrawableById("RightGoalMeter");
        mDrawables[:DataArea] = View.findDrawableById("DataArea");
        mDrawables[:Indicators] = View.findDrawableById("Indicators");

        mTime = View.findDrawableById("Time");

        mDataFields = View.findDrawableById("DataFields");
        mDrawables[:MoveBar] = View.findDrawableById("MoveBar");

        setHideSeconds(Application.Properties.getValue("HideSeconds"));
    }
    
    function setHideSeconds(hideSeconds){
        if(mIsBurnInProtection || (mTime == null)){
            return;
        }
        mTime.setHideSeconds(hideSeconds);
        (mDrawables[:MoveBar] as MoveBar).setFullWidth(hideSeconds);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var amPmString = "AM";
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
                amPmString = "PM";
            }else{
                amPmString = "AM";
            }
        } else {
            if (Application.Properties.getValue("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Update the view
        var view = View.findDrawableById("TimeLabel") as Text;
        view.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        view.setText(timeString);

        var amPmLabel = View.findDrawableById("AmPmLabel") as Text;
        amPmLabel.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        amPmLabel.setText(amPmString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    function onSettingChanged(){
        mSettingChangedSinceLastDraw = true;

        updateNormalFont();
        updateThemeColors();
    }

    function updateNormalFont(){
        var city = Application.Properties.getValue("LocalTimeInCity");

        //gNormalFont = WatchUi.loadResource(((city != null) && (city.length() > 0)) ?  Rez.Fonts.NormalFontCities : Rez.Fonts.NormalFont);
    }

    function updateThemeColors(){
        var theme = Application.getApp().getIntProperty("Theme",0);
        gThemeColor = [
            Graphics.COLOR_BLUE,
            Graphics.COLOR_PINK,
            Graphics.COLOR_GREEN,
            Graphics.COLOR_DK_GRAY,
            0x55AAFF,
            0xFFFFAA,
            Graphics.COLOR_ORANGE,
            Graphics.COLOR_RED,
            Graphics.COLOR_WHITE,
            Graphics.COLOR_DK_BLUE,
            Graphics.COLOR_DK_GREEN,
            Graphics.COLOR_DK_RED,
            0xFFFF00,
            Graphics.COLOR_ORANGE,
            Graphics.COLOR_YELLOW
        ][theme];

        var lightFlags = [
            false,
            false,
            false,
            true,
            false,
            false,
            false,
            false,
            false,
            true,
            true,
            true,
            false,
            true,
            false,
        ];

        var isFr45 = (System.getDeviceSettings().screenWidth == 208);
        if(lightFlags[theme]){
            gMonoLightColor = Graphics.COLOR_BLACK;
            gMonoDarkColor = isFr45 ? Graphics.COLOR_BLACK : Graphics.COLOR_DK_GRAY;

            gMeterBackgroundColor = isFr45 ? Graphics.COLOR_BLACK : Graphics.COLOR_LT_GRAY;
            gBackgroundColor = Graphics.COLOR_WHITE;
        }else{
            gMonoLightColor = Graphics.COLOR_WHITE;
            gMonoDarkColor = isFr45 ? Graphics.COLOR_WHITE : Graphics.COLOR_LT_GRAY;

            gMeterBackgroundColor = isFr45 ? Graphics.COLOR_WHITE : Graphics.COLOR_DK_GRAY;
            gBackgroundColor = Graphics.COLOR_BLACK;
        }
    }

}
