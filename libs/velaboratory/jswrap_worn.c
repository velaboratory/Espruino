#include "jswrap_worn.h"
#include "jsvar.h"
#include "jshardware.h"
#include "jsinteractive.h"


/*JSON{
  "type" : "event",
  "class" : "Bangle",
  "name" : "isWorn",
  "params" : [["data","JsVar",""]],
  "ifdef" : "BANGLEJS",
  "typescript": "on(event: \"isWorn\", callback: (data: isWornData) => void): void;"
}
* `isWorn contains if the watch is currently being worn(true/false)'

*/

void checkIsWornEvent(){
    static uint64_t currentTime = 0;
    static uint64_t lastSampleTime = 0;
    static uint64_t oneMinute = 60000;
  
    //turn on IR leds
    //take a reading(takes a few seconds)
    currentTime = jshGetSystemTime();
    if (jshGetMillisecondsFromTime(currentTime - lastSampleTime) >= (oneMinute - 5000)) {
      isWorn = worn();
    }
    if (jshGetMillisecondsFromTime(currentTime - lastSampleTime) >= oneMinute) {
      lastSampleTime = currentTime;
      emitIsWornEvent(true);
    }
}

bool worn(){
  //turn on irleds
  return true;
}

void emitIsWornEvent(bool isWorn){
  JsVar *bangle = jsvObjectGetChildIfExists(execInfo.root, "Bangle");
  if(bangle){
      JsVar *o = jsvNewObject();
      if(o){
        jsvObjectSetChildAndUnLock(o, "isWorn", jsvNewFromBool(isWorn));
      }
      jsiQueueObjectCallbacks(bangle, JS_EVENT_PREFIX"isWorn", &o, 1);
      jsvUnLock(o);
      jshHadEvent();
    }
  jsvUnLock(bangle);
}