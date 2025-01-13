import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

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
        mFieldTypes[0] = getIntProperty("Field1Type", 0);
        mFieldTypes[1] = getIntProperty("Field2Type", 1);
        mFieldTypes[2] = getIntProperty("Field3Type", 2);

        mView.onSettingChanged();
        WatchUi.requestUpdate();
    }

    function getIntProperty(key, defaultValue){
        var value = Properties.getValue(key);
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
        }
    }
}

function getApp() as face1App {
    return Application.getApp() as face1App;
}