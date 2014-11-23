#! /usr/bin/env python

import unittest
from adb import Adb

class TestAdb (unittest.TestCase):
    def setUp(self):
        self.longMessage = True

    def testInit(self):
        self.assertIsNotNone(Adb())


    def testListDevices(self):
        #devices = Adb().getDevices()
        None
        #self.assertEquals(devices, "none")
