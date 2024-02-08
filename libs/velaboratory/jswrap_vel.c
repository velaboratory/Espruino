#include "jswrap_vel.h"
#include "examples/example_event.h"
#include "jswrap_heartrate_collections.h"
#include "jswrap_worn.h"
#include "jsvar.h"
#include "jsinteractive.h"


extern JsVar *events;

void velPollHandler(){
    //collect_heartrate_samples();
    check_heartrate_collections_event();
    checkIsWornEvent();

    checkExampleEvent();
}

/*JSON{
  "type" : "class",
  "class" : "Vel"
}
A class to support some simple drawings and animations (rotate and shift)
For a LED Matrix like the 8*8 WS2812 board
*/

/*JSON{
  "type" : "staticmethod",
  "class" : "Vel",
  "name" : "getEvents",
  "generate" : "jswrap_vel_getEvents",
  "return" : ["JsVar","Number Of Stored Events"]
}
 */

JsVar* jswrap_vel_getEvents(){
    int32_t numEvents = jsvGetArrayLength(events);
    bool hasEvents = jsvArrayIsEmpty(events);
    JsVar *obj = jsvNewObject();
    jsvObjectSetChildAndUnLock(obj, "events", jsvNewFromInteger(numEvents));
    jsvObjectSetChildAndUnLock(obj, "hasEvents", jsvNewFromBool(hasEvents));
    return obj;
}