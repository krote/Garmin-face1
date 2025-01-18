using Toybox.Background as Bg;
using Toybox.System as Sys;
using Toybox.Communications as Comms;
using Toybox.Application as App;

import Toybox.Lang;

typedef CityLocalTimeSuccessResponse as {
    "requestCity" as String,
    "city" as String,
    "current" as {
        "gmtOffset" as Number,
        "dst" as Boolean
    },
    "next" as {
        "when" as Number,
        "gmOffset" as Number,
        "dst" as Boolean
    }
};

typedef CityLocalTimeErrorResponse as {
    "requestCity" as String,
    "error" as {
        "code" as Number,
        "message" as String
    }
};

typedef CityLocalTimeResponse as CityLocalTimeSuccessResponse or CityLocalTimeErrorResponse;
typedef CityLocalTimeData as CityLocalTimeResponse;

typedef OpenWeatherMapCurrentSuccessResponse as {
    "cond" as {
        "lon" as Number,
        "lat" as Number
    },
    "weather" as Array<{
        "id" as Number,
        "main" as String,
        "description" as String,
        "icon" as String
    }>,
    "base" as String,
    "main" as {
        "temp" as Number,
        "pressure" as Number,
        "humidty" as Number,
        "temp_min" as Number,
        "temp_max" as Number
    },
    "visibility" as Number,
    "wind" as {
        "speed" as Number,
        "deg" as Number
    },
    "clouds" as {
        "all" as Number
    },
    "dt" as Number,
    "sys" as {
        "type" as Number,
        "id" as Number,
        "message" as Number,
        "country" as String,
        "sunrise" as Number,
        "sunset" as Number,
    },
    "id" as Number,
    "name" as String,
    "cod" as Number
};

typedef OpenWeatherMapCurrentErrorResponse as {
    "cod" as Number,
    "message" as String
};

typedef OpenWeatherMapCurrentResponse as OpenWeatherMapCurrentSuccessResponse or OpenWeatherMapCurrentErrorResponse;

typedef OpenWeatherMapCurrentData as {
    "cod" as Number,
    "lat" as Number,
    "lon" as Number,
    "dt" as Number,
    "temp" as Number,
    "humidity" as Number,
    "icon" as String
};

(:background)
class BackgroundService extends Sys.ServiceDelegate {
    (:background_method)
    function initialize(){
        System.ServiceDelegate.initialize();
    }

    (:background_method)
    function onTemporalEvent(){
        var pendingWebRequests = getStorageValue("PendingWebRequests") as PendingWebRequests?;
        if(pendingWebRequests != null){
            // 1. City local time
            if(pendingWebRequests["CityLocalTime"] != null){
                makeWebRequest(
                    "", 
                    {
                        "city" => getApp().Properties.getValue("LocalTimeInCity")
                    }, 
                    method(:onReceiveCityLocalTime)
                );
            }else if(pendingWebRequests["OpenWeatherMapCurrent"] != null){
                var owmKeyOverride = getApp().Properties.getValue("OWMKeyOverride");
                makeWebRequest(
                    url, 
                    {
                        "lat" => getStorageValue("LastLocationLat"),
                        "lng" => getStorageValue("LastLocationLng"),
                        "appid" => ((owmKeyOverride != null) && (owmKeyOverride.length() == 0)) ? 
                    }, options, responseCallback
                );
            }
        }
    }

    (:background_method)
    function onReceiveCityLocalTime(responseCode as Number, data as CityLocalTimeResponse?){

    }
}