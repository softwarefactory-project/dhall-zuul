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

def comment(name):
    return "{- " + name + " -}\n"

def create_schemas(kv):
    return "{" + " , ".join(map(lambda i: " = ".join(i), kv))+ "}"

def create_typesUnion(kv):
    return "<" + " | ".join(map(lambda i: " : ".join(i), kv))+ ">"

def capitalize(n):
    return ''.join(map(str.capitalize, n.split('-')))

def path_to_attr_name(p):
    return p.name.replace('.dhall', '') if p.parent == Path('.') else p.parent.name

def create_records(fns):
    return sorted(list(map(lambda f: (path_to_attr_name(Path(f)), f), fns)))

def create_records_capitalize(fns):
    return [(capitalize(k), v) for k, v in create_records(fns)]

def create_object_package(obj):
    return create_schemas(create_records(list(map(
        lambda v: "./" + v,
        filter(
            lambda v: v != "package.dhall", os.listdir("Zuul/" + obj))))))

def create_wrap_function(obj):
    obj_type = "./Type.dhall"
    obj_unions = "../../typesUnion.dhall"
    obj_lower = obj.lower()
    return ("../../imports/map.dhall " + obj_type + " " + obj_unions +
         (" (\(%s : %s) -> (%s).%s { %s }) " % (obj_lower, obj_type, obj_unions, obj, obj_lower)))

def inout(command):
    return lambda stdin: subprocess.Popen(["dhall", "--ascii"] + command, stdin=subprocess.PIPE, stdout=subprocess.PIPE).communicate(
        stdin.encode('utf-8'))[0].decode('utf-8')
dhall_format = inout(["format"])
dhall_freeze = inout(["freeze", "--all"])

def write(dest, content, freeze=False):
    old = None
    if dest.parent != Path("."):
        old = os.getcwd()
        os.chdir(dest.parent)
    try:
        content = dhall_format(content)
        if freeze:
            content = dhall_freeze(content)
    finally:
        if old:
            os.chdir(old)
    if not dest.exists() or dest.read_text() != content:
        dest.write_text(content)
        print("%s: updated!" % dest)

def freeze(dest, content):
    return write(dest, content, freeze=True)

def listdir(dname):
    return list(map(lambda s: "./" + str(dname / s), filter(lambda s: s.endswith(".dhall"), os.listdir(dname))))

def run():
    conf_objects = ["Job", "Nodeset", "Project"]
    objects = list(filter(lambda x: "." not in x, os.listdir("Zuul")))
    schemas = list(map(lambda v: "./Zuul/%s/package.dhall" % v, objects))
    types = list(map(lambda v: "./Zuul/%s/wrapped.dhall" % v, conf_objects))

    for obj in objects:
        if obj in conf_objects:
            write(Path("./Zuul/%s/wrapped.dhall" % obj), comment("A wrapped version of the Zuul.%s.Type" % obj) + "{ %s : ./Type.dhall }" % obj.lower())
            write(Path("./Zuul/%s/wrap.dhall" % obj), comment("A function to wrap a list of Zuul.%s.Type" % obj) + create_wrap_function(obj))
        if Path("./Zuul/%s/default.dhall" % obj).exists() and Path("./Zuul/%s/Type.dhall" % obj).exists():
            write(Path("./Zuul/%s/schema.dhall" % obj), comment("A completable Zuul.%s record" % obj) + "{ Type = ./Type.dhall, default = ./default.dhall }")
        write(Path("./Zuul/%s/package.dhall" % obj), comment("The Zuul.%s package" % obj) + create_object_package(obj))
    freeze(Path("typesUnion.dhall"), comment("The Zuul Union to group different schemas in a single list") + create_typesUnion(create_records(types)))
    freeze(Path("schemas.dhall"), comment("The Zuul schemas collection") + create_schemas(create_records(schemas)))
    freeze(Path("package.dhall"), comment("The dhall-zuul entry point") + "./schemas.dhall // { Resource = ./typesUnion.dhall }")

if __name__ == "__main__":
    run()
