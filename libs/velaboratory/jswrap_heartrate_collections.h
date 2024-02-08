#ifndef JSWRAP_HEARTRATE_COLLECTIONS_H
#define JSWRAP_HEARTRATE_COLLECTIONS_H

#include "jsvar.h"

void collect_heartrate_samples();

void check_heartrate_collections_event();

void emit_heartrate_collections_event();
#endif