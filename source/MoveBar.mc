using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;
using Toybox.ActivityMonitor;
using Toybox.Graphics;

import Toybox.Lang;

class MoveBar extends WatchUi.Drawable {
    private var mX, mY, mBaseWidth, mHeight, mSeparator;
    private var mTailWidth;

    (:buffered) private var mBuffer;
    (:buffered) private var mBufferNeedsRedraw;

    private var mBufferNeedRecreate = true;
    private var mIsFullWidth = false;

    typedef MoveBarParams as {
        :x as Number,
        :y as Number,
        :width as Number,
        :height as Number,
        :separator as Number    
    };

    function initialize(params){
        Drawable.initialize(params);

        mX = params[:x];
        mY = params[:y];
        mBaseWidth = params[:width];
        mHeight = params[:height];
        mSeparator = params[:separator];

        mTailWidth = mHeight / 2;
    }

    function setFullWidth(fullWidth){
        if(mIsFullWidth != fullWidth){
            mIsFullWidth = fullWidth;
            mBufferNeedRecreate = true;
        }
    }
}
