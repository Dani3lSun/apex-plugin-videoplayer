# Oracle APEX Region Plugin - Video Player
HTML5 Video Player. Region Plugin using OpenSource JS framework "video.js" to display HTML5 videos.

video.js (https://github.com/videojs/video.js)

## Changelog
####1.0.0 - Initial Release

## Install
- Import plugin file "region_type_plugin_de_danielh_videoplayer" from source directory into your application
- (Optional) Deploy the CSS/JS files from "server" directory on your webserver and change the "File Prefix" to webservers folder.

## Plugin Settings
The plugin settings are highly customizable and you can change:
- **Width** - Width of video player in pixels
- **Height** - Height of video player in pixels
- **Show controls** - Whether or not the player has controls that the user can interact with. Without controls the only way to start the video playing is with the autoplay attribute
- **Autoplay** - If autoplay is true, the video will start playing as soon as page is loaded (without any interaction from the user). NOT SUPPORTED BY APPLE iOS DEVICES!
- **Loop** - The loop attribute causes the video to start over as soon as it ends
- **Preload** - The preload attribute informs the browser whether or not the video data should begin downloading as soon as the video tag is loaded. The options are auto, metadata, and none
- **Style** - Default style of the video player (Default & Big Play Button centered)
- **No Javascript message** - Message that should be displayed if the browser doesn´t support javascript videos
- **Language** - Default language of video player
- **Video URL Column** - Column of SQL query which contains the video URL path
- **Poster Image URL Column** - Column of SQL query which contains the poster URL path to an preview image file
- **Mime Type Column** - Column of SQL query which contains the mime type of the video file
- **Alt. Video URL Column** - Column of SQL query which contains the alternative video URL path
- **Alt. Mime Type Column** - Column of SQL query which contains the alternative mime type of the video file
- **Logging** - Whether to log events in the console

## Plugin Events
- **APEX Video ended** - DA event to do things when a video ends

#### Example SQL Query:
```language-sql
SELECT video_url (VARCHAR2),
       poster_url (VARCHAR2),
       mime_type (VARCHAR2),
       alternative_video_url (VARCHAR2), (optional)
       alternative_mime_type (VARCHAR2), (optional)
FROM videos

SELECT '/web/path/to/my/video.mp4' AS video_url,
       '/web/path/to/my/poster.png' AS poster_url,
       'video/mp4' AS mime_type,
       '/web/path/to/my/video.webm' AS alternative_video_url,
       'video/webm' AS alternative_mime_type
FROM dual
```
## Demo Application
https://apex.oracle.com/pls/apex/f?p=APEXPLUGIN

## Preview
![](https://raw.githubusercontent.com/Dani3lSun/apex-plugin-videoplayer/master/preview.gif)
---
