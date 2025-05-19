import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application.Properties;

using Toybox.Background as Bg;

typedef PendingWebRequests as Dictionary<String, Boolean>;

var gLocationLat = null;
var gLocationLng = null;

(:object_store)
function getStorageValue(key as PropertyKeyType) as PropertyValueType {
	return Application.getApp().getProperty(key);
}
(:object_store)
function setStorageValue(key as PropertyKeyType, value as PropertyValueType) as Void {
	Application.getApp().setProperty(key, value);
}
(:object_store)
function deleteStorageValue(key as PropertyKeyType) as Void {
	Application.getApp().deleteProperty(key);
}

class face1App extends Application.AppBase {
    var mView;
    var mFieldTypes as Array<Number> = [0,0,0];

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() {
        mView = new face1View();
        onSettingsChanged();
        return [mView];
    }

    function getView(){
        return mView;
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
        // Use try/catch for each property in case they don't exist
        try {
            mFieldTypes[0] = getIntProperty("Field1Type", 0);
        } catch (e) {
            mFieldTypes[0] = 0;
            Properties.setValue("Field1Type", 0);
        }
        
        try {
            mFieldTypes[1] = getIntProperty("Field2Type", 1);
        } catch (e) {
            mFieldTypes[1] = 1;
            Properties.setValue("Field2Type", 1);
        }
        
        try {
            mFieldTypes[2] = getIntProperty("Field3Type", 2);
        } catch (e) {
            mFieldTypes[2] = 2;
            Properties.setValue("Field3Type", 2);
        }

        mView.onSettingChanged();
        WatchUi.requestUpdate();
    }

    function getIntProperty(key, defaultValue){
        var value = null;
        try {
            value = Properties.getValue(key);
        } catch (e) {
            // Key does not exist, use default value
            value = defaultValue;
            // Create property if it doesn't exist
            Properties.setValue(key, defaultValue);
            return value;
        }
        
        if(value == null){
            value = defaultValue;
        }else if(!(value instanceof Number)){
            value = value.toNumber();
        }
        return value;
    }

    function hasField(fieldType){
        return ( (mFieldTypes[0] == fieldType) ||
            (mFieldTypes[1] == fieldType) ||
            (mFieldTypes[2] == fieldType));
    }

    (:background_method)
    function checkPendingWebRequests(){
        var location = Activity.getActivityInfo().currentLocation;
        if(location != null){
            location = location.toDegrees();
            gLocationLat = location[0].toFloat();
            gLocationLng = location[1].toFloat();

            setStorageValue("LastLocationLat", gLocationLat);
            setStorageValue("LastLocationLng", gLocationLng);
        }else{
            var lat = getStorageValue("LastLocationLat");
            if(lat != null){
                gLocationLat = lat;
            }
            var lng = getStorageValue("LastLocationLng");
            if(lng != null){
                gLocationLng = lng;
            }
        }

        if(!(System has :ServiceDelegate)){
            return;
        }

        var pendingWebRequests = getStorageValue("PendingWebRequests") as PendingWebRequests?;
        if(pendingWebRequests == null){
            pendingWebRequests = {};
        }

        // 1.City local time. City has been specified
        var city = Application.getApp().getProperty("LocalTimeInCity");

        if((city != null) && (city.length() > 0)){
            var cityLocalTime = getStorageValue("CityLocalTime") as CityLocalTimeResponse?;

            if((cityLocalTime == null) ||
            (((cityLocalTime as CityLocalTimeSuccessResponse)["next"] != null) && (Time.now().value() >= (cityLocalTime as CityLocalTimeSuccessResponse)["next"]["when"]))){
                pendingWebRequests["CityLocalTime"] = true;
            }else if(!cityLocalTime["requestCity"].equals(city)){
                deleteStorageValue("CityLocalTime");
                pendingWebRequests["CityLocalTime"] = true;
            }
        }

        if((gLocationLat != null) &&
            (hasField(FIELD_TYPE_WEATHER) || hasField(FIELD_TYPE_HUMIDITY))){
            var ownCurrent = getStorageValue("OpenWeatherMapCurrent") as OpenWeatherMapCurrentData?;

            if(ownCurrent == null){
                pendingWebRequests["OpenWeatherCurrent"] = true;
            }else if(ownCurrent["cod"] == 200){
                if((Time.now().value() > (ownCurrent["dt"] + 1800)) ||
                    (((gLocationLat - ownCurrent["lat"]).abs() > 0.02) || ((gLocationLat - ownCurrent["lon"]).abs() > 0.02))){
                        pendingWebRequests["OpenWeatherCurrent"] = true;
                }
            }
        }

        if(pendingWebRequests.keys().size() > 0){
            var lastTime = Bg.getLastTemporalEventTime();
            if(lastTime != null){
                var nextTime = lastTime.add(new Time.Duration(5*60));
                Bg.registerForTemporalEvent(nextTime);
            }else{
                Bg.registerForTemporalEvent(Time.now());
            }
        }
        setStorageValue("PendingWebRequests", pendingWebRequests);
    }
}

function getApp() as face1App {
    return Application.getApp() as face1App;
}