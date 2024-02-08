#ifndef JSWRAP_WORN_H
#define JSWRAP_WORN_H

#include "jsvar.h"

bool isWorn = false;

void checkIsWornEvent();
bool worn();
void emitIsWornEvent(bool isWorn);
#endif