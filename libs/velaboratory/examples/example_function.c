#include "jsvar.h"
#include "example_function.h"

/*JSON{
  "type" : "staticmethod",
  "class" : "Vel",
  "name" : "getExampleFunction",
  "generate" : "jswrap_vel_getExampleFunction",
  "return" : ["JsVar","Number Of Stored Events"]
}
 */

JsVar* jswrap_vel_getExampleFunction(){
    JsVar *obj = jsvNewObject();
    jsvObjectSetChildAndUnLock(obj, "exampleFunctionObject", jsvNewFromInteger(1));
    return obj;
}