#! usr/bin/env python

import unittest

import sys
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

        expectedCommand = 'command! Grand :python SetupCommands().displayEmptyCommand()'
        vim_mock.command.assert_called_with(expectedCommand)

    @patch('setup_commands.vim')
    def testAddCommandGrandSetup(self, vim_mock):

        SetupCommands().addCommandGrandSetup()

        expectedCommand = 'command! GrandSetup :python GrandSetup().executeCommand()'
        vim_mock.command.assert_called_with(expectedCommand)

    @patch('setup_commands.vim')
    def testAddCommandGrandTags(self, vim_mock):

        SetupCommands().addCommandGrandTags()

        expectedCommand = 'command! GrandTags :python GrandTags().executeCommand()'
        vim_mock.command.assert_called_with(expectedCommand)


    @patch('setup_commands.vim')
    def testAddCommandGrandInstall(self, vim_mock):

        SetupCommands().addCommandGrandInstall()

        expectedCommand = 'command! GrandInstall :python GrandInstall().executeCommand()'
        vim_mock.command.assert_called_with(expectedCommand)

    @patch('setup_commands.vim')
    def testSetupCommandCalling(self, vim_mock):

        SetupCommands().setupCommandCalling('GrandTest')

        expectedCommand1 = ':python from command_test.grand_test import GrandTest'
        expectedCommand2 = 'command! GrandTest :python GrandTest().executeCommand()'
        vim_mock.command.assert_any_call(expectedCommand1)
        vim_mock.command.assert_any_call(expectedCommand2)


