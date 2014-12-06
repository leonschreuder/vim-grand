#! usr/bin/env python

import unittest

import sys
import os
from mock import patch
from mock import MagicMock

# We don't actually use this mock, but otherwise python can't find the vim
# module at all because it is only available when run from vim
sys.modules['vim'] = MagicMock() 

from setup_commands import SetupCommands

class SetupCommandsTest (unittest.TestCase):

    @patch('setup_commands.vim')
    def testExecute(self, vim_mock):
        SetupCommands().execute()

        vim_mock.command.assert_called_with('command! Grand :python SetupCommands().displayEmptyCommand()')

    @patch('setup_commands.vim')
    def testAddCommandGrandSetup(self, vim_mock):

        SetupComand().AddCommandGrandSetup()

        vim_mock.command.assert_called_with('command! GrandSetup :python SetupCommands().AddCommandGrandSetup()')
