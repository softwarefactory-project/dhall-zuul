#!/bin/env python3
# Copyright 2020 Red Hat
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
""" Generate the top-level files """

import subprocess
import os
from pathlib import Path

def create_schemas(kv):
    return "{" + " , ".join(map(lambda i: " = ".join(i), kv))+ "}"

def create_main_schema(obj):
    obj_type = "../types/%s.dhall" % obj
    obj_box = "../boxed-types/%s.dhall" % obj
    res = "../typesUnion.dhall"
    return "{ " + " , ".join([
        "Type = " + obj_type,
        "default = ../defaults/" + obj + ".dhall",
        "Box = " + obj_box,
        "pack = ../functions/map.dhall " + obj_type + " " + res + (" (\(%s : %s) -> (%s).%s { %s }) " % (obj, obj_type, res, obj.capitalize(), obj))
        ]) + " }"

def create_schema(obj):
    obj_type = "../types/%s.dhall" % obj
    obj_def = "../defaults/%s.dhall" % obj
    return "{ " + " , ".join([
        "Type = " + obj_type,
        "default = " + obj_def
        ]) + " }"

def create_typesUnion(kv):
    return "<" + " | ".join(map(lambda i: " : ".join(i), kv))+ ">"

def capitalize(n):
    return ''.join(map(str.capitalize, n.split('-')))

def create_records(fns):
    return list(map(lambda f: (capitalize(Path(f.split('/')[2]).name.replace('.dhall', '')), f), fns))

def inout(command):
    return lambda stdin: subprocess.Popen(["dhall", "--ascii"] + command, stdin=subprocess.PIPE, stdout=subprocess.PIPE).communicate(
        stdin.encode('utf-8'))[0].decode('utf-8')
dhall_format = inout(["format"])
dhall_freeze = inout(["freeze", "--all"])

def write(dest, content):
    old = None
    if dest.parent != Path("."):
        old = os.getcwd()
        os.chdir(dest.parent)
    try:
        content = dhall_format(content)
    finally:
        if old:
            os.chdir(old)
    if not dest.exists() or dest.read_text() != content:
        dest.write_text(content)
        print("%s: updated!" % dest)

def listdir(dname):
    return list(map(lambda s: "./" + str(dname / s), filter(lambda s: s.endswith(".dhall"), os.listdir(dname))))

def run():
    objects = ["job", "nodeset", "project"]

    for obj in objects:
        write(Path("./boxed-types/%s.dhall" % obj), "{ %s : ../types/%s.dhall }" % (obj, obj))
        if obj != "project":
            write(Path("./schemas/%s.dhall" % obj), create_main_schema(obj))

    sub_objects = ["project-pipeline"]
    for obj in sub_objects:
        write(Path("./schemas/%s.dhall" % obj), create_schema(obj))

    schemas = list(map(lambda v: "./schemas/%s.dhall" % v, objects + sub_objects))
    types = list(map(lambda v: "./boxed-types/%s.dhall" % v, objects))

    write(Path("unions.dhall"), create_schemas(create_records(listdir(Path("./unions/")))))
    write(Path("schemas.dhall"), create_schemas(create_records(schemas)))
    write(Path("typesUnion.dhall"), create_typesUnion(create_records(types)))

if __name__ == "__main__":
    run()
