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
    private var mIsOff = false;

    (:buffered) private var mFilledBuffer;
    (:buffered) private var mEmptyBuffer;

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
        var segmentScale = getSegmentScale();

        var numSegments = mMaxValue * 1.0 / segmentScale;
        var numSeparators = Math.ceil(numSegments) - 1;

        var totalSegmentHeight = mHeight - (numSeparators * mSeparator);
        var segmentHeight = totalSegmentHeight * 1.0 / numSegments;

        var segments = new [Math.ceil(numSegments)];
        var start, end, height;
        for(var i = 0; i < segments.size(); ++i){
            start = Math.round(i * segmentHeight);
            end = Math.round((i+1) * segmentHeight);

            if(end > totalSegmentHeight){
                end = totalSegmentHeight;
            }
            height = end - start;
            segments[i] = height.toNumber();
        }
        return segments;
    }

    function getSegmentScale(){
        var segmentScale;
        var tryScaleIndex = 0;
        var segmentHeight;
        var numSegments;
        var numSeparators;
        var totalSegmentHeight;

        var SEGMENT_SCALES = [1, 10, 100, 1000, 10000];

        // Check if mMaxValue is null or zero to avoid division by zero
        if (mMaxValue == null || mMaxValue == 0) {
            return SEGMENT_SCALES[0]; // Return default scale
        }

        do{
            segmentScale = SEGMENT_SCALES[tryScaleIndex];

            numSegments = mMaxValue * 1.0 /segmentScale;
            numSeparators = Math.ceil(numSegments);
            totalSegmentHeight = mHeight - (numSeparators * mSeparator);
            segmentHeight = Math.floor(totalSegmentHeight / numSegments);

            tryScaleIndex++;
            // Prevent infinite loop if we reach the end of SEGMENT_SCALES
            if (tryScaleIndex >= SEGMENT_SCALES.size()) {
                break;
            }
        }while(segmentHeight <= /* MIN_WHOLE_SEGMENT_HEIGHT */ 5);
        return segmentScale;
    }

    function getFillHeight(segments as Array<Number>){
        var fillHeight;
        var i;
        var totalSegmentHeight = 0;
        for(i=0; i < segments.size() ; ++i){
            totalSegmentHeight += segments[i];
        }

        var remainingFillHeight = Math.floor((mCurrentValue * 1.0 / mMaxValue) * totalSegmentHeight).toNumber();
        fillHeight = remainingFillHeight;

        for(i=0; i < segments.size(); ++i){
            remainingFillHeight -= segments[i];
            if(remainingFillHeight > 0){
                fillHeight += mSeparator;
            }else{
                break;
            }
        }
        return fillHeight;
    }

    // Differennt draw algorithms have been tried:
    (:unbuffered)
    function draw(dc){
        var meterStyle = Application.Properties.getValue("GoalMeterStyle");
        if((meterStyle == 2 /* HIDDEN */) || mIsOff){
            return;
        }

        var left = (mSide == :left) ? 0 : (dc.getWidth() - mWidth);
        var top = (dc.getHeight() - mHeight) / 2;

        //mBufferNeedRecreate; mBufferNeedRedraw;
        if(gThemeColor == null){
            gThemeColor = Graphics.COLOR_BLACK;
        }

        if(mSegments == null){
            mSegments = getSegments();
        }
        drawSegments(dc, left, top, gThemeColor, mSegments, 0, mFillHeight);

        if(meterStyle <= 1){
            drawSegments(dc, left, top, gMeterBackgroundColor, mSegments, mFillHeight, mHeight);
        }
    }
/*
    (:buffered)
    function draw(dc){
        if((Application.Properties.getValue("GoalMeterStyle") == 2 ) || mIsOff){ //2:HIDDEN
            return;
        }

        var left = (mSide == :left) ? 0 : (dc.getWidth()-mWidth);
        var top = (dc.getHeight() - mHeight) / 2;

        var emptyBufferDc;
        var filledBufferDc;

        var clipBottom, clipTop, clipHeight;

        var halfScreenDcWidth = (dc.getWidth() / 2);
        var x, radius;

        if(mBufferNeedRecreate){
            mEmptyBuffer = createSegmentBuffer(gMeterBackgroundColor);
            mFilledBuffer = createSegmentBuffer(gThemeColor);
            mBufferNeedRecreate = false;
            mBufferNeedRedraw = true;
        }

        if(mBufferNeedRedraw){
            // clear both buffers with background color
            emptyBufferDc = mEmptyBuffer.getDc();
            emptyBufferDc.setColor(Graphics.COLOR_TRANSPARENT, gBackgroundColor);
            emptyBufferDc.clear();
            
            filledBufferDc = mFilledBuffer.getDc();
            filledBufferDc.setColor(Graphics.COLOR_TRANSPARENT, gBackgroundColor);
            filledBufferDc.clear();

            // draw full fill height for each buffer
            drawSegments(emptyBufferDc, 0, 0, gMeterBackgroundColor, mSegments, 0, mHeight);
            // cloud avoid drawing filled segments buffer if style is not ALL_SEGMENTS or ALL_SEGMENTS_MERTGED
            drawSegments(filledBufferDc, 0, 0, gThemeColor, mSegments, 0, mHeight);

            // for arc meters, draw circular mask for each buffer.
            if( System.getDeviceSettings().screenShape != System.SCREEN_SHAPE_RECTANGLE){
                // beyond right edge of bufferDc : beyond left edge of bufferDc
                x = (mSide == :left) ? halfScreenDcWidth : (mWidth - halfScreenDcWidth - 1);
                radius = halfScreenDcWidth - mStroke;

                emptyBufferDc.setColor(gBackgroundColor, Graphics.COLOR_TRANSPARENT);
                emptyBufferDc.fillCircle(x, (mHeight / 2), radius);

                filledBufferDc.setColor(gBackgroundColor, Graphics.COLOR_TRANSPARENT);
                filledBufferDc.fillCircle(x, (mHeight / 2), radius);
            }

            mBufferNeedRedraw = false;
        }

        //draw filled segments
        clipBottom = dc.getHeight() - top;
        clipTop = clipBottom - mFillHeight;
        clipHeight = clipBottom - clipTop;

        if(clipHeight > 0){
            dc.setClip(left, clipTop, mWidth, clipHeight);
            dc.drawBitmap(left, top, mFilledBuffer);
        }

        // draw unfilled segments
        if( Application.Properties.getValue("GoalMeterStyle") <= 1){
            clipBottom = clipTop;
            clipTop = top;
            clipHeight = clipBottom - clipTop;

            if(clipHeight > 0){
                dc.setClip(left, clipTop, mWidth, clipHeight);
                dc.drawBitmap(left, top, mEmptyBuffer);
            }
        }

        dc.clearClip();
    }
*/
    function drawSegments(dc, x, y, fillColor, segments as Array<Number>, startFillHeight, endFillHeight){
        var segmentStart = 0;
        var segmentEnd;
        var fillStart, fillEnd, fillHeight;

        y += mHeight; // start from bottom
        dc.setColor(fillColor, Graphics.COLOR_TRANSPARENT);

        for(var i = 0; i < segments.size(); ++i){
            segmentEnd = segmentStart + segments[i];

            // Full segment is filled
            if((segmentStart >= startFillHeight) && (segmentEnd <= endFillHeight)){
                fillStart = segmentStart;
                fillEnd = segmentEnd;

            }else if(segmentStart >= startFillHeight) {// Bottom of this segment is filled
                fillStart =  segmentStart;
                fillEnd = endFillHeight;
            }else if(segmentEnd <= endFillHeight){ // Top of this segment is filled
                fillStart = startFillHeight;
                fillEnd = segmentEnd;
            }else { // Segment is not filled
                fillStart = 0;
                fillEnd = 0;
            }

            fillHeight = fillEnd - fillStart;
            if(fillHeight){
                dc.fillRectangle(x, y, -fillStart - fillHeight, mWidth, fillHeight);
            }
            segmentStart = segmentEnd + mSeparator;

        }
    }

    (:buffered)
    function createSegmentBuffer(fillColor){
        var options = {
            :width => mWidth,
            :height => mHeight,
            :palette => [gBackgroundColor, fillColor]
        };

        if((Graphics has :createBufferdBitmap)){
            return Graphics.createBufferedBitmap(options).get();
        }
        return new Graphics.BufferedBitmap(options);
    }
}
