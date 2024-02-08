#include "jswrap_heartrate_collections.h"
#include "jsvar.h"
#include "jshardware.h"
#include "jsinteractive.h"
#include "heartrate.h"

/*JSON{
  "type" : "event",
  "class" : "Bangle",
  "name" : "heartrateCollections",
  "params" : [["data","JsVar",""]],
  "ifdef" : "BANGLEJS",
  "typescript": "on(event: \"heartrateCollections\", callback: (data:heartrateCollectionsData) => void): void;"
}
* ` heartrateCollections contains the last 10 heartrate samples containing only the moving average and raw of those samples'

*/

uint8_t sample_num = 0;
int16_t averages_data[10];
int16_t raw_data[10];

void collect_heartrate_samples(){
    averages_data[sample_num] = hrmInfo.avg;
    raw_data[sample_num] = hrmInfo.raw;
    sample_num++;
}

void check_heartrate_collections_event(){
    if (sample_num >= 10){
        emit_heartrate_collections_event();
        sample_num = 0;
    }
}

void emit_heartrate_collections_event(){
  JsVar *bangle = jsvObjectGetChildIfExists(execInfo.root, "Bangle");
  if(bangle){
      JsVar *o = jsvNewObject();
      if(o){
        jsvObjectSetChildAndUnLock(o, "averages", jsvNewArrayBufferWithData(20,averages_data)); // one int16 takes two spots because this is in int8
        jsvObjectSetChildAndUnLock(o, "raw", jsvNewArrayBufferWithData(20,raw_data)); // one int16 takes two spots because this is in int8
      }
      jsiQueueObjectCallbacks(bangle, JS_EVENT_PREFIX"heartrateCollections", &o, 1);
      jsvUnLock(o);
      jshHadEvent();
    }
  jsvUnLock(bangle);
}