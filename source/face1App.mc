import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

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

}

function getApp() as face1App {
    return Application.getApp() as face1App;
}