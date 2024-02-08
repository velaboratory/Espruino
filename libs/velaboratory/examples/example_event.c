#include "jsvar.h"
#include "jshardware.h"
#include "jsinteractive.h"
#include "example_event.h"

/*JSON{
  "type" : "event",
  "class" : "Bangle",
  "name" : "exampleEvent",
  "params" : [["data","JsVar",""]],
  "ifdef" : "BANGLEJS",
  "typescript": "on(event: \"exampleEvent\", callback: (data: exampleEventObject) => void): void;"
}

*/

void emitExampleEvent(){
  JsVar *bangle = jsvObjectGetChildIfExists(execInfo.root, "Bangle");
  if(bangle){
      JsVar *o = jsvNewObject();
      if(o){
        jsvObjectSetChildAndUnLock(o, "exampleEventObject", jsvNewFromInteger(1));
      }
      jsiQueueObjectCallbacks(bangle, JS_EVENT_PREFIX"exampleEvent", &o, 1);
      jsvUnLock(o);
      jshHadEvent();
    }
  jsvUnLock(bangle);
}

void checkExampleEvent(){
    static uint64_t currentTime = 0;
    static uint64_t lastSampleTime = 0;
    static uint64_t halfMinute = 30000;

    currentTime = jshGetSystemTime();
    if (jshGetMillisecondsFromTime(currentTime - lastSampleTime) >= halfMinute) {
      lastSampleTime = currentTime;
      emitExampleEvent();
    }
}