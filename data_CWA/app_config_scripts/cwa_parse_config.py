#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import CWAConfig_pb2 as CWAConfig

config = CWAConfig.ApplicationConfiguration()
with open("../app_config/app_config_2020-08-17.bin", "rb") as fd:
    config.ParseFromString(fd.read())

print(config) 
