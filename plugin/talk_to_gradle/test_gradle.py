#! /usr/bin/env python

import unittest
import sys
from gradle import Gradle
from mock import patch
from mock import MagicMock

# We don't actually use this mock, but otherwise python can't find the vim
# module at all because it is only available when run from vim
sys.modules['vim'] = MagicMock() 

class TestGradle (unittest.TestCase):

    def setUp(self):
        MockSysHelper.gradleWrapperReturnValue = None
        MockSysHelper.gradleReturnValue = None


    def testInit(self):
        gradle = Gradle()
        self.assertIsNotNone(gradle.sysHelper)

        gradle.sysHelper = MockSysHelper()
        self.assertIsInstance(gradle.sysHelper, MockSysHelper)

    
    def test_hasGradleWithoutGradle_shouldReturnFalse(self):
        self.initGradleWithMockSysHelper()

        self.assertFalse(self.gradle.hasGradle())
    
    def test_hasGradleWithGradle_shouldReturnTrue(self):
        self.initGradleWithMockSysHelper()
        self.letSystemHaveGradle()

        self.assertTrue(self.gradle.hasGradle())
        self.assertEquals("gradle", self.gradle.sysHelper.wasCalledWith)
    
    def test_hasGradleWrapperWhenAvailable_shouldReturnTrue(self):
        self.initGradleWithMockSysHelper()
        self.letSystemHaveGradleWrapper()

        self.assertTrue(self.gradle.hasGradleWrapper())
        self.assertEquals("./gradlew", self.gradle.sysHelper.wasCalledWith)


    @patch('talk_to_gradle.gradle.vim')
    def test_hasDispatchInstalled_shouldEvalVimExists(self, mock_vim):

        Gradle().hasDispatchInstalled();

        mock_vim.eval.assert_called_with("exists(':Dispatch')")

    @patch('talk_to_gradle.gradle.vim')
    def test_executeCommandWithGradleWrapperAndDispatchAvailable_shouldCallGradleWrapperWithDispatch(self, mock_vim):
        self.initGradleWithMockSysHelper()
        self.letSystemHaveGradle()
        self.letSystemHaveGradleWrapper()
        mock_vim.eval.return_value = True

        self.gradle.executeGradleCommand('clean')

        mock_vim.command.assert_called_with('Dispatch ./gradlew clean -q')

    @patch('talk_to_gradle.gradle.vim')
    def test_executeCommandWithGradleAndDispatchAvailable_shouldCallGradleWithDispatch(self, mock_vim):
        self.initGradleWithMockSysHelper()
        self.letSystemHaveGradle()
        mock_vim.eval.return_value = True

        self.gradle.executeGradleCommand('clean')

        mock_vim.command.assert_called_with('Dispatch gradle clean -q')

    @patch('talk_to_gradle.gradle.vim')
    def test_executeCommandWithGradleWithoutDispatch_shouldCallGradleWithVanillaBang(self, mock_vim):
        self.initGradleWithMockSysHelper()
        mock_vim.eval.return_value = False

        self.gradle.executeGradleCommand('clean')

        mock_vim.command.assert_called_with('! gradle clean -q')

    # HELPERS
    #----------------------------------------
    def initGradleWithMockSysHelper(self):
        self.gradle = Gradle()
        self.gradle.sysHelper = MockSysHelper()

    def letSystemHaveGradle(self):
        MockSysHelper.gradleReturnValue = "anythingButNone"

    def letSystemHaveGradleWrapper(self):
        MockSysHelper.gradleWrapperReturnValue = "anythingButNone"


class MockSysHelper:

    def which(self, program):

        self.wasCalledWith = program

        if program == './gradlew':
            return self.gradleWrapperReturnValue
        elif program == 'gradle':
            return self.gradleReturnValue
        else:
            return None
