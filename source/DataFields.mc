using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Application as App;
using Toybox.Activity as Activity;
using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.SensorHistory as SensorHistory;

using Toybox.Time;
using Toybox.Time.Gregorian;

import Toybox.Lang;

enum /* FIELD_TYPES */ {
	// Pseudo-fields.	
	FIELD_TYPE_SUNRISE = -1,	
	//FIELD_TYPE_SUNSET = -2,

	// Real fields (used by properties).
	FIELD_TYPE_HEART_RATE = 0,
	FIELD_TYPE_BATTERY,
	FIELD_TYPE_NOTIFICATIONS,
	FIELD_TYPE_CALORIES,
	FIELD_TYPE_DISTANCE,
	FIELD_TYPE_ALARMS,
	FIELD_TYPE_ALTITUDE,
	FIELD_TYPE_TEMPERATURE,
	FIELD_TYPE_BATTERY_HIDE_PERCENT,
	FIELD_TYPE_HR_LIVE_5S,
	FIELD_TYPE_SUNRISE_SUNSET,
	FIELD_TYPE_WEATHER,
	FIELD_TYPE_PRESSURE,
	FIELD_TYPE_HUMIDITY
}

class DataFields extends Ui.Drawable{
	typedef DataFieldsParams as {
		:left as Number,
		:right as Number,
		:top as Number,
		:bottom as Number,
		:batteryWidth as Number
	};

	private var mLeft, mRight, mTop, mBottom, mBatteryWidth;
	private var mFieldCount;
	private var mHasLiveHR = false;
	private var mWasHRAvailable = false;
	private var mMaxFieldLength;
	private var mWeatherIconsFont = null;
	private var mWeatherIconsSubset = null;
	

	function initialize(params as DataFieldsParams){
		Drawable.initialize(params);

		mLeft = params[:left];
		mRight = params[:right];
		mTop = params[:top];
		mBottom = params[:bottom];
		mBatteryWidth = params[:batteryWidth];

		onSettingChanged();
	}

	function onSettingChanged(){
		mFieldCount = App.getApp().getIntProperty("FieldCount", 3);
		mMaxFieldLength = [0, 8, 6, 4][mFieldCount];
		mHasLiveHR  = App.getApp().hasField(FIELD_TYPE_HR_LIVE_5S);

		if(!App.getApp().hasField(FIELD_TYPE_WEATHER)){
			mWeatherIconsFont = null;
			mWeatherIconsSubset = null;
		}
	}
	
	function draw(dc as Gfx.Dc) as Void {
		// Required implementation of draw method since this class extends Drawable
		// Will be implemented with actual drawing logic
	}
}