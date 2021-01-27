# Copyright 2021 Red Hat, Inc.
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

"""
A script to generate pipeline trigger/reporters from zuul schemas
Run it with ~/src/opendev.org/zuul/zuul/.tox/py36/bin/python
"""

import subprocess
import voluptuous
from pathlib import Path
import zuul.driver

import zuul.driver.elasticsearch
import zuul.driver.gerrit
import zuul.driver.git
import zuul.driver.github
import zuul.driver.gitlab
import zuul.driver.mqtt
import zuul.driver.pagure
import zuul.driver.smtp
import zuul.driver.sql
import zuul.driver.timer


drivers = [
    zuul.driver.elasticsearch.ElasticsearchDriver(),
    zuul.driver.gerrit.GerritDriver(),
    zuul.driver.git.GitDriver(),
    zuul.driver.github.GithubDriver(),
    zuul.driver.gitlab.GitlabDriver(),
    zuul.driver.mqtt.MQTTDriver(),
    zuul.driver.pagure.PagureDriver(),
    zuul.driver.smtp.SMTPDriver(),
    zuul.driver.sql.SQLDriver(),
    zuul.driver.timer.TimerDriver(),
]


def driverName(name):
    if name == "github":
        return "GitHub"
    elif name == "gitlab":
        return "GitLab"
    else:
        return name.capitalize()


def nameToDhall(name):
    # Converts `require-approval` to `RequireApproval`
    return "".join(map(str.capitalize, name.split("-")))


def mkUnion(items):
    # Returns a Dhall union
    return "\n".join(["<", " | ".join(sorted(items)), ">"])


def dhall_write(file_path, file_content):
    # Write and format a file
    file_path.parent.mkdir(parents=True, exist_ok=True)
    file_path.write_text(file_content)
    subprocess.Popen(["dhall", "--ascii", "format", "--inplace", str(file_path)]).wait()


def voluptuous_to_dhall(schema_dict):
    # Return a list of [(file_path, file_content)]
    type_record = []
    other = []

    # Voluptuous schema can be wrapped in a Schema object, the true schema is then in the .schema attribute
    if hasattr(schema_dict, "schema"):
        schema_dict = schema_dict.schema

    # When the schema is Any or empty, returns an empty type
    if isinstance(schema_dict, voluptuous.validators.Any) or schema_dict is None:
        return []

    for (k, v) in schema_dict.items():
        is_optional = not isinstance(k, voluptuous.schema_builder.Required)
        # When the key is wrapped in a Required object, get the true key name from the .schema attribute
        key_name = k if is_optional else k.schema
        is_list = False
        dhall_type = "None"

        if hasattr(v, "validators"):
            # In zuul schemas, lists are `scalar_or_list`, which means ([a], a) where a == a
            if len(v.validators) == 2 and v.validators[0][0] == v.validators[1]:
                is_list = True
                # Remove the list wrapper
                v = v.validators[1]

        if hasattr(v, "validators") and type(v.validators[0]) == str:
            # The value is list of possible text, convert this to a Dhall union.
            fn = "./" + nameToDhall(key_name) + ".dhall"
            other.append((fn, mkUnion(v.validators)))
            dhall_type = fn

        if isinstance(v, voluptuous.schema_builder.Schema):
            # The value is a nested record
            fn = "./" + nameToDhall(key_name) + "/Type.dhall"
            if k != "approval":
                # The approval value is manually written to handle arbitrary Text or Integer values
                other += list(
                    map(
                        lambda n: (Path(nameToDhall(key_name)) / n[0], n[1]),
                        voluptuous_to_dhall(v),
                    )
                )
            dhall_type = fn

        if v == int:
            dhall_type = "Integer"
        elif v == bool:
            dhall_type = "Bool"
        elif v == str:
            dhall_type = "Text"
        elif key_name == "topic":
            # Special case for MQTT which use a custom validator
            dhall_type = "Text"
        elif key_name == "qos":
            # Special case for MQTT which use a custom validator
            fn = "./QOS.dhall"
            other.append((fn, mkUnion(["`0`", "`1`", "`2`"])))
            dhall_type = fn

        if dhall_type == "None":
            raise RuntimeError("Need type for: " + str(k) + " " + str(v))

        if is_list:
            dhall_type = "(List %s)" % dhall_type
        if is_optional:
            dhall_type = "Optional %s" % dhall_type
        type_record.append((key_name, dhall_type))

    if not type_record:
        return []

    return [
        (
            "Type.dhall",
            "\n".join(
                [
                    "{",
                    " , ".join("`" + k + "` : " + v for k, v in sorted(type_record)),
                    "}",
                ]
            ),
        ),
        ("default.dhall", "-- to be filled by shake\n{=}"),
        ("package.dhall", "-- to be filled by shake\n{=}"),
    ] + other


def render_schema(name, schema_name, schema_dict):
    schema_root = Path("Zuul/Pipeline/") / schema_name / name
    print(schema_root)
    for (fp, fc) in voluptuous_to_dhall(schema_dict):
        dhall_write(schema_root / fp, fc)


def render_schemas(obj):
    name, schemas = obj
    list(map(lambda schema: render_schema(name, schema[0], schema[1]), schemas))


def get_schemas(driver):
    schemas = []
    if isinstance(driver, zuul.driver.TriggerInterface):
        schemas.append(("Trigger", driver.getTriggerSchema()))
    if isinstance(driver, zuul.driver.ReporterInterface):
        schemas.append(("Reporter", driver.getReporterSchema()))
    if isinstance(driver, zuul.driver.SourceInterface):
        schemas.append(("Require", driver.getRequireSchema()))
    return schemas


def render_unions(driver_schemas):
    unions = dict()
    for driver, schemas in driver_schemas:
        for (schema, _) in schemas:
            unions.setdefault(schema, []).append(driver)
    for union, drivers in unions.items():
        root = Path("Zuul") / "Pipeline" / union
        prefix = "List " if union == "Trigger" else ""
        union_value = []
        for name in drivers:
            attr = "(./Type.dhall)." + name
            if (root / name / "Type.dhall").exists():
                value = prefix + "./" + name + "/Type.dhall"
            else:
                value = "List Text"
                attr += " ([] : List Text)"
            dhall_write(root / (name.lower() + ".dhall"), attr)
            union_value.append(name + " : " + value)

        dhall_write(root / "Type.dhall", mkUnion(union_value))


drivers_schemas = list(
    map(
        lambda driver: (
            driverName(driver.name),
            get_schemas(driver),
        ),
        drivers,
    )
)

list(map(render_schemas, drivers_schemas))
render_unions(drivers_schemas)
