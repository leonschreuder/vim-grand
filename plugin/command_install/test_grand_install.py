#! /usr/bin/env python

import unittest
import sys
import os
from mock import patch
from mock import MagicMock

# We don't actually use this mock, but otherwise python can't find the vim
# module at all because it is only available when run from vim
sys.modules['vim'] = MagicMock() 

from command_install.grand_install import GrandInstall

class TestGrandInstall (unittest.TestCase):

    @patch('command_install.grand_install.Adb')
    def testVimGrandInstallsLatest(self, mock_adb):

        GrandInstall().executeCommand();

        mock_adb.return_value.installLatestApk.assert_called_with()


    #@patch('command_install.grand_install.vim')
    #def testVimGrandCtagsFileWithDispatch(self, mock_vim):

        #GrandInstall().executeCommand();

        #mock_vim.eval.assert_any_call("exists(':Dispatch')")
        #mock_vim.command.assert_called_with('Dispatch gradle installDebug -q')

    #@patch('command_install.grand_install.vim')
    #def testVimGrandCtagsFileWithBang(self, mock_vim):
        #mock_vim.eval.return_value = False

        #GrandInstall().executeCommand();

        #mock_vim.eval.assert_any_call("exists(':Dispatch')")
        #mock_vim.command.assert_called_with('! gradle installDebug -q')

    @patch('command_install.grand_install.vim')
    def testHasDispatchInstalled(self, mock_vim):

        GrandInstall().hasDispatchInstalled();

        mock_vim.eval.assert_called_with("exists(':Dispatch')")


    @patch('command_install.grand_install.vim')
    def testInstallUsingDispatch(self, mock_vim):

        GrandInstall().installUsingDispatch();

        mock_vim.command.assert_called_with('Dispatch gradle installDebug -q')


    @patch('command_install.grand_install.vim')
    def testInstallUsingVanillaShell(self, mock_vim):

        GrandInstall().installUsingVanillaBang()

        mock_vim.command.assert_called_with('! gradle installDebug -q')

    @patch('command_install.grand_install.Adb')
    def testGetDevices(self, mock_adb):

        GrandInstall().installThroughAdb()

        mock_adb.return_value.installLatestApk.assert_called_with()
        #mock_subprocess.Popen.assert_called_with(['TEST_ANDROID_HOME/platform-tools/adb', 'devices'])
