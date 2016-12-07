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


object usage as DeepFrozen:
    to version():
        return "Grail v0.0.1"

    to general():
        return "\n".join([
            "grail <command>",
            "",
            "Welcome to Monte's Holy Grail!",
            "Here are the available commands:",
            "\t\thelp [command]\tShow this help text or the help of a command",
            "\t\tnew <project name>\tCreate a new Monte project",
            "\t\tversion\t Display Grail's version number"])

    to onCommand(command :Str):
        return "Command specific help text coming soon"


def makeWriteAccess(makeFileResource) as DeepFrozen:
    "a la python pathlib, with some Emily influence"
    return def writeAccessTo(here: Str):
        def f := makeFileResource(here)

        return object writeAccess:
            to _printOn(out):
                return out.print(`<write to $here>`)

            to path():
                return here

            to approxDivide(sub :Str):
                "pathlib idiom: here / sub"
                def there := `$here/$sub`
                if (there.split("/").contains("..")):
                    throw(`no .. allowed: $there`)
                return writeAccessTo(there)

            to with_suffix(suffix :Str):
                if (suffix.contains('/')):
                    throw(`no / allowed in suffix: $suffix`)
                return writeAccessTo(here + suffix)

            to setContents(bs :Bytes):
                return f.setContents(bs)


def main(argv, => stdio, => makeFileResource) :Int as DeepFrozen:
    def stderr := stdio.stderr()
    def eprintln(x):
        def line := `$x$\n`
        stderr(b`$line`)

    def cwd := makeWriteAccess(makeFileResource)(".")

    return switch (argv):
        match [=="new", name]:
            new_project(name, cwd)
        match [=="version"]:
            eprintln(usage.version())
        match [=="help"]:
            eprintln(usage.general())
        match [=="help", what]:
            eprintln(usage.onCommand(what))
        match [command]:
            eprintln(usage.onCommand(command))
            1
        match _:
            eprintln(usage.general())
            1
