#! /usr/bin/env python

class VimMock():
    def __init__(self):
        self.commandInput = []
        self.evalInput = []

    def command(self, commandInput):
        self.commandInput += [commandInput]

    def eval(self, evalInput):
        if (evalInput == 's:python_folder_path'):
            return '/current_script_dir'
        self.evalInput += [evalInput]
