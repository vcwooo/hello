
import 'dart:async';

import 'package:flutter/services.dart';

class Hello {
  String path;
  Hello(this.path);
  static const MethodChannel _channel = MethodChannel('hello');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future setExif(Map exif) async {
    //android查看https://developer.android.google.cn/reference/android/support/media/ExifInterface?hl=zh-cn
    //ios查看https://developer.apple.com/documentation/imageio/cgimageproperties/exif_dictionary_keys
    await _channel.invokeMethod('setExif',<String, dynamic>{'path': path,'exif':exif});
  }
  Future setDate(String date)async{
    var platform = await Hello.platformVersion;
    if(platform!.contains('iOS')){
      await setExif({'DateTimeOriginal':date});
    }
  }
  Future setGps(Map location)async{
    var platform = await Hello.platformVersion;
    if(platform!.contains('iOS')){
      await _channel.invokeMethod('setGps',<String, dynamic>{'path': path,'gps':{
        'Latitude':location['lat'],
        'LatitudeRef':location['lat']>0?'N':'S',
        'Longitude':location['lng'],
        'LongitudeRef':location['lng']>0?'E':'W',
        'ImgDirection':location['img_dir']
      }});
    }
  }
  gpsInfoConvert(num coordinate){
    String sb = '';
    if (coordinate < 0) {
      coordinate = -coordinate;
    }
    num degrees = coordinate.floor();
    sb += degrees.toString() + '/1,';
    coordinate -= degrees;
    coordinate *= 60.0;
    num minutes = coordinate.floor();
    sb += minutes.toString() + '/1,';
    coordinate -= minutes.toDouble();
    coordinate *= 60.0;
    sb += coordinate.floor().toString() + '/1,';
    return sb;
  }
}
