# A script to generate pipeline trigger/reporters from zuul schema
# Run it with ~/src/opendev.org/zuul/zuul/.tox/py36/bin/python

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
    return "".join(map(str.capitalize, name.split("-")))


def mkUnion(items):
    return "\n".join(["<", " | ".join(sorted(items)), ">"])


def dhall_write(fp, fc):
    fp.parent.mkdir(parents=True, exist_ok=True)
    fp.write_text(fc)
    subprocess.Popen(["dhall", "--ascii", "format", "--inplace", str(fp)]).wait()


def voluptuous_to_dhall(schema_dict):
    type_record = []
    other = []
    if hasattr(schema_dict, "schema"):
        schema_dict = schema_dict.schema

    if isinstance(schema_dict, voluptuous.validators.Any) or schema_dict is None:
        return []

    for (k, v) in schema_dict.items():
        is_optional = not isinstance(k, voluptuous.schema_builder.Required)
        key_name = k if is_optional else k.schema
        is_list = False
        dhall_type = "None"

        if hasattr(v, "validators"):
            if len(v.validators) == 2 and v.validators[0][0] == v.validators[1]:
                is_list = True
                v = v.validators[1]

        if hasattr(v, "validators") and type(v.validators[0]) == str:
            fn = "./" + nameToDhall(key_name) + ".dhall"
            other.append((fn, mkUnion(v.validators)))
            dhall_type = fn
        if isinstance(v, voluptuous.schema_builder.Schema):
            fn = "./" + nameToDhall(key_name) + "/Type.dhall"
            if k != "approval":
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
            dhall_type = "Text"
        elif key_name == "qos":
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
