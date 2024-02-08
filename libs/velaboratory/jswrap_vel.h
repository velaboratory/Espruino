#ifndef JSWRAP_VEL_H
#define JSWRAP_VEL_H

#include "jsvar.h"
#include "jsinteractive.h"

void velPollHandler();

JsVar* jswrap_vel_getEvents();
JsVar* jswrap_vel_getExample();
#endif