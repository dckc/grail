# Copyright 2016 Justin Noah <justinnoah@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
import "src/create"  =~ [=> new_project :DeepFrozen]
exports (main)


def grail_version() as DeepFrozen:
    traceln("Grail v0.0.1")


def help_string(eprintln, name :Str) as DeepFrozen:
    if (name == ""):
        eprintln("grail <command>")
        eprintln("Welcome to Monte's Holy Grail!")
        eprintln("Here are the available commands:")
        eprintln("\t\thelp [command]\tShow this help text or the help of a command")
        eprintln("\t\tnew <project name>\tCreate a new Monte project")
        eprintln("\t\tversion\t Display Grail's version number")
    else:
        eprintln("Command specific help text coming soon")


def main(argv, => stdio, => makeFileResource) as DeepFrozen:
    def stderr := stdio.stderr()
    def eprintln(x):
        stderr(b`${`$x$\n`}`)

    switch (argv):
        match [=="new", name]:
            new_project(name, makeFileResource)
        match [=="version"]:
            grail_version()
        match [command]:
            help_string(eprintln, command)
        match [=="help", what]:
            help_string(eprintln, what)
        match _:
            help_string(eprintln, "")
