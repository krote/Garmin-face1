import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class face1App extends Application.AppBase {

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
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new face1View() ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
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