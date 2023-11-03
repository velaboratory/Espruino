/*
 * This file is part of Espruino, a JavaScript interpreter for Microcontrollers
 *
 * Copyright (C) 2013 Gordon Williams <gw@pur3.co.uk>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * ----------------------------------------------------------------------------
 * I2C Utility functions, and software I2C
 * ----------------------------------------------------------------------------
 */
#ifndef JSI2C_H_
#define JSI2C_H_

#include "jsvar.h"
#include "jshardware.h"

bool jsi2cPopulateI2CInfo(
    JshI2CInfo *inf,
    JsVar      *options
  );

#if ESPR_NO_SOFTWARE_I2C!=1
void jsi2cSetup(JshI2CInfo *inf);
void jsi2cUnsetup(JshI2CInfo *inf); ///< turn off I2C (remove pullups/sense)
bool jsi2cWrite(JshI2CInfo *inf, unsigned char address, int nBytes, const unsigned char *data, bool sendStop);
bool jsi2cRead(JshI2CInfo *inf, unsigned char address, int nBytes, unsigned char *data, bool sendStop);
#endif // ESPR_NO_SOFT_I2C

#endif // JSI2C_H_
