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