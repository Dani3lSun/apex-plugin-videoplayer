// APEX Video functions
// Author: Daniel Hochleitner
// Version: 1.0.0

// global namespace
var apexVideo = {
  // parse string to boolean
  parseBoolean: function(pString) {
    var pBoolean;
    if (pString.toLowerCase() == 'true') {
      pBoolean = true;
    }
    if (pString.toLowerCase() == 'false') {
      pBoolean = false;
    }
    if (!(pString.toLowerCase() == 'true') && !(pString.toLowerCase() == 'false')) {
      pBoolean = undefined;
    }
    return pBoolean;
  },
  // function that gets called from plugin
  apexVideoFnc: function(pRegionId, pOptions, pLogging) {
    var vOptions = pOptions;
    var vRegion$ = jQuery('#' + apex.util.escapeCSS(pRegionId + '_video'), apex.gPageContext$);
    var vRegion = apex.util.escapeCSS(pRegionId + '_video');
    var vLogging = apexVideo.parseBoolean(pLogging);
    var vWidth = parseInt(vOptions.width);
    var vHeight = parseInt(vOptions.height);
    var vControls = apexVideo.parseBoolean(vOptions.controls);
    var vAutoplay = apexVideo.parseBoolean(vOptions.autoplay);
    var vLoop = apexVideo.parseBoolean(vOptions.loop);
    var vPreload = vOptions.preload;
    var vPosterUrl = vOptions.poster;
    var vLanguage = vOptions.language;
    // set max. screen width
    var vScreenWidth = window.screen.width;
    if (vWidth > vScreenWidth) {
      vWidth = vScreenWidth;
    }
    // VideoJS Setup
    var vSetup = {
      "techOrder": ['html5', 'flash'],
      "width": vWidth,
      "height": vHeight,
      "controls": vControls,
      "preload": vPreload,
      "autoplay": vAutoplay,
      "loop": vLoop,
      "poster": vPosterUrl,
      "language": vLanguage
    };
    // Logging
    if (vLogging) {
      console.log('apexVideoFnc: vOptions.width:', vOptions.width);
      console.log('apexVideoFnc: screen width:', vScreenWidth);
      console.log('apexVideoFnc: vOptions.height:', vOptions.height);
      console.log('apexVideoFnc: vOptions.controls', vOptions.controls);
      console.log('apexVideoFnc: vOptions.autoplay:', vOptions.autoplay);
      console.log('apexVideoFnc: vOptions.loop:', vOptions.loop);
      console.log('apexVideoFnc: vOptions.preload:', vOptions.preload);
      console.log('apexVideoFnc: vOptions.poster:', vOptions.poster);
      console.log('apexVideoFnc: vOptions.language:', vOptions.language);
      console.log('apexVideoFnc: pRegionId:', pRegionId);
      console.log('apexVideoFnc: vRegion:', vRegion);
      console.log('apexVideoFnc: vRegion$:', vRegion$);
      console.log('apexVideoFnc: Videojs vSetup:', vSetup);
    }
    // Initial Video Player
    var myPlayer = videojs(vRegion, vSetup, function() {
      var myPlayer = this;
      // EVENTS
      // ended event
      myPlayer.on('ended', function() {
        $('#' + pRegionId).trigger('apexvideo-ended');
      });
    });
  }
};
