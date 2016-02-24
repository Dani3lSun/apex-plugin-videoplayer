/*-------------------------------------
 * APEX Video Plugin
 * Version: 1.0.0 (24.02.2016)
 * Author:  Daniel Hochleitner
 *-------------------------------------
*/
FUNCTION render_video(p_region              IN apex_plugin.t_region,
                      p_plugin              IN apex_plugin.t_plugin,
                      p_is_printer_friendly IN BOOLEAN)
  RETURN apex_plugin.t_region_render_result IS
  -- plugin attributes
  l_width                NUMBER := p_region.attribute_01;
  l_height               NUMBER := p_region.attribute_02;
  l_show_controls        VARCHAR2(50) := p_region.attribute_03;
  l_autoplay             VARCHAR(50) := p_region.attribute_04;
  l_loop                 VARCHAR2(50) := p_region.attribute_05;
  l_preload              VARCHAR(50) := p_region.attribute_06;
  l_style                VARCHAR2(100) := p_region.attribute_07;
  l_nojs_message         VARCHAR2(500) := p_region.attribute_08;
  l_language             VARCHAR(50) := p_region.attribute_09;
  l_video_url_column     VARCHAR2(100) := p_region.attribute_10;
  l_poster_url_column    VARCHAR2(100) := p_region.attribute_11;
  l_mime_type_column     VARCHAR2(100) := p_region.attribute_12;
  l_alt_video_url_column VARCHAR2(100) := p_region.attribute_13;
  l_alt_mime_type_column VARCHAR2(100) := p_region.attribute_14;
  l_logging              VARCHAR(50) := p_region.attribute_15;
  -- other variables
  l_region_id        VARCHAR2(200);
  l_width_esc        VARCHAR2(50);
  l_height_esc       VARCHAR2(50);
  l_nojs_message_esc VARCHAR2(500);
  -- js/css file vars
  l_apexvideo_js VARCHAR2(50);
  l_videojs_js   VARCHAR2(50);
  l_videojs_css  VARCHAR2(50);
  -- vars for SQL source
  l_column_value_list   apex_plugin_util.t_column_value_list2;
  l_video_url_no        PLS_INTEGER;
  l_poster_url_no       PLS_INTEGER;
  l_mime_type_no        PLS_INTEGER;
  l_alt_video_url_no    PLS_INTEGER;
  l_alt_mime_type_no    PLS_INTEGER;
  l_video_url_value     VARCHAR2(500);
  l_poster_url_value    VARCHAR2(500);
  l_mime_type_value     VARCHAR2(200);
  l_alt_video_url_value VARCHAR2(500);
  l_alt_mime_type_value VARCHAR2(200);
  --
BEGIN
  -- Debug
  IF apex_application.g_debug THEN
    apex_plugin_util.debug_region(p_plugin => p_plugin,
                                  p_region => p_region);
    -- set js/css filenames
    l_apexvideo_js := 'apexvideo';
    l_videojs_js   := 'video';
    l_videojs_css  := 'video-js';
  ELSE
    l_apexvideo_js := 'apexvideo.min';
    l_videojs_js   := 'video.min';
    l_videojs_css  := 'video-js.min';
  END IF;
  -- set variables and defaults
  l_region_id     := apex_escape.html_attribute(p_region.static_id ||
                                                '_video');
  l_style         := nvl(l_style,
                         'DEFAULT');
  l_show_controls := nvl(l_show_controls,
                         'true');
  l_autoplay      := nvl(l_autoplay,
                         'false');
  l_loop          := nvl(l_loop,
                         'false');
  l_preload       := nvl(l_preload,
                         'auto');
  l_language      := nvl(l_language,
                         'en');
  l_logging       := nvl(l_logging,
                         'false');
  l_nojs_message  := nvl(l_nojs_message,
                         'To view this video please enable JavaScript, and consider upgrading to a web browser that supports');
  -- escape input
  l_width_esc        := sys.htf.escape_sc(l_width);
  l_height_esc       := sys.htf.escape_sc(l_height);
  l_nojs_message_esc := sys.htf.escape_sc(l_nojs_message);
  --
  -- Get Data from Source
  l_column_value_list := apex_plugin_util.get_data2(p_sql_statement  => p_region.source,
                                                    p_min_columns    => 3,
                                                    p_max_columns    => 5,
                                                    p_component_name => p_region.name);
  --
  -- Get columns and validate
  -- video url
  l_video_url_no := apex_plugin_util.get_column_no(p_attribute_label   => 'Video URL',
                                                   p_column_alias      => l_video_url_column,
                                                   p_column_value_list => l_column_value_list,
                                                   p_is_required       => TRUE,
                                                   p_data_type         => apex_plugin_util.c_data_type_varchar2);
  -- poster url
  l_poster_url_no := apex_plugin_util.get_column_no(p_attribute_label   => 'Poster URL',
                                                    p_column_alias      => l_poster_url_column,
                                                    p_column_value_list => l_column_value_list,
                                                    p_is_required       => TRUE,
                                                    p_data_type         => apex_plugin_util.c_data_type_varchar2);
  -- mime type
  l_mime_type_no := apex_plugin_util.get_column_no(p_attribute_label   => 'Mime type',
                                                   p_column_alias      => l_mime_type_column,
                                                   p_column_value_list => l_column_value_list,
                                                   p_is_required       => TRUE,
                                                   p_data_type         => apex_plugin_util.c_data_type_varchar2);
  -- alt video url
  l_alt_video_url_no := apex_plugin_util.get_column_no(p_attribute_label   => 'Alt Video URL',
                                                       p_column_alias      => l_alt_video_url_column,
                                                       p_column_value_list => l_column_value_list,
                                                       p_is_required       => FALSE,
                                                       p_data_type         => apex_plugin_util.c_data_type_varchar2);
  -- alt mime type
  l_alt_mime_type_no := apex_plugin_util.get_column_no(p_attribute_label   => 'Alt Mime type',
                                                       p_column_alias      => l_alt_mime_type_column,
                                                       p_column_value_list => l_column_value_list,
                                                       p_is_required       => FALSE,
                                                       p_data_type         => apex_plugin_util.c_data_type_varchar2);
  --
  -- Get values from SQL query
  -- video url
  l_video_url_value := apex_plugin_util.get_value_as_varchar2(p_data_type => l_column_value_list(l_video_url_no)
                                                                             .data_type,
                                                              p_value     => l_column_value_list(l_video_url_no)
                                                                             .value_list(1));
  -- poster url
  l_poster_url_value := apex_plugin_util.get_value_as_varchar2(p_data_type => l_column_value_list(l_poster_url_no)
                                                                              .data_type,
                                                               p_value     => l_column_value_list(l_poster_url_no)
                                                                              .value_list(1));
  -- mime type
  l_mime_type_value := apex_plugin_util.get_value_as_varchar2(p_data_type => l_column_value_list(l_mime_type_no)
                                                                             .data_type,
                                                              p_value     => l_column_value_list(l_mime_type_no)
                                                                             .value_list(1));
  -- alt video url
  IF l_alt_video_url_no IS NOT NULL THEN
    l_alt_video_url_value := apex_plugin_util.get_value_as_varchar2(p_data_type => l_column_value_list(l_alt_video_url_no)
                                                                                   .data_type,
                                                                    p_value     => l_column_value_list(l_alt_video_url_no)
                                                                                   .value_list(1));
  END IF;
  -- alt mime type
  IF l_alt_mime_type_no IS NOT NULL THEN
    l_alt_mime_type_value := apex_plugin_util.get_value_as_varchar2(p_data_type => l_column_value_list(l_alt_mime_type_no)
                                                                                   .data_type,
                                                                    p_value     => l_column_value_list(l_alt_mime_type_no)
                                                                                   .value_list(1));
  END IF;
  --
  -- add video tag for videojs
  -- default style
  IF l_style = 'DEFAULT' THEN
    sys.htp.p('<video id="' || l_region_id ||
              '" class="video-js vjs-default-skin">');
    sys.htp.p('<source src="' || l_video_url_value || '" type="' ||
              l_mime_type_value || '">');
    -- alternative video source
    IF l_alt_video_url_value IS NOT NULL AND
       l_alt_mime_type_value IS NOT NULL THEN
      sys.htp.p('<source src="' || l_alt_video_url_value || '" type="' ||
                l_alt_mime_type_value || '">');
    END IF;
    sys.htp.p('<p class="vjs-no-js">' || l_nojs_message_esc ||
              ' <a href="http://videojs.com/html5-video-support/" target="_blank">HTML5 video</a></p>');
    sys.htp.p('</video>');
    -- big play button centered style
  ELSIF l_style = 'BIGPLAYBUTTONCENTER' THEN
    sys.htp.p('<video id="' || l_region_id ||
              '" class="video-js vjs-default-skin vjs-big-play-centered">');
    sys.htp.p('<source src="' || l_video_url_value || '" type="' ||
              l_mime_type_value || '">');
    -- alternative video source
    IF l_alt_video_url_value IS NOT NULL AND
       l_alt_mime_type_value IS NOT NULL THEN
      sys.htp.p('<source src="' || l_alt_video_url_value || '" type="' ||
                l_alt_mime_type_value || '">');
    END IF;
    sys.htp.p('<p class="vjs-no-js">' || l_nojs_message_esc ||
              ' <a href="http://videojs.com/html5-video-support/" target="_blank">HTML5 video</a></p>');
    sys.htp.p('</video>');
  END IF;
  --
  -- add videojs js and apexvideo
  apex_javascript.add_library(p_name           => l_videojs_js,
                              p_directory      => p_plugin.file_prefix,
                              p_version        => NULL,
                              p_skip_extension => FALSE);
  --
  apex_javascript.add_library(p_name           => l_apexvideo_js,
                              p_directory      => p_plugin.file_prefix,
                              p_version        => NULL,
                              p_skip_extension => FALSE);
  --
  -- add videojs css
  apex_css.add_file(p_name      => l_videojs_css,
                    p_directory => p_plugin.file_prefix);
  --
  -- onload code
  apex_javascript.add_onload_code(p_code => 'apexVideo.apexVideoFnc(' ||
                                            apex_javascript.add_value(p_region.static_id) || '{' ||
                                            apex_javascript.add_attribute('width',
                                                                          l_width_esc) ||
                                            apex_javascript.add_attribute('height',
                                                                          l_height_esc) ||
                                            apex_javascript.add_attribute('controls',
                                                                          l_show_controls) ||
                                            apex_javascript.add_attribute('autoplay',
                                                                          l_autoplay) ||
                                            apex_javascript.add_attribute('loop',
                                                                          l_loop) ||
                                            apex_javascript.add_attribute('preload',
                                                                          l_preload) ||
                                            apex_javascript.add_attribute('poster',
                                                                          l_poster_url_value) ||
                                            apex_javascript.add_attribute('language',
                                                                          l_language,
                                                                          FALSE,
                                                                          FALSE) || '},' ||
                                            apex_javascript.add_value(l_logging,
                                                                      FALSE) || ');');
  --
  RETURN NULL;
  --
END render_video;