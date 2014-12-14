#! /usr/bin/env python

import unittest
import os

from mock import patch
from utils import Utils

class TestUtils (unittest.TestCase):

    @patch('utils.utils.os')
    def test_is_exe(self, mock_os):

        Utils().is_exe('path')

        mock_os.path.isfile.assert_called_with('path')
        mock_os.access.assert_called_with('path', mock_os.X_OK)
