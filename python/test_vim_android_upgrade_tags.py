#! /usr/bin/env python

import unittest
from vim_mock import VimMock
import sys
import os
sys.modules['vim'] = VimMock()

import vim_android_upgrade_tags

class TestAndroidUpgradeTags (unittest.TestCase):

    def setUp(self):
        self.vim = sys.modules['vim']

    def test(self):
        vim_android_upgrade_tags
        None
