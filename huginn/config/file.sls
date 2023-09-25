# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as huginn with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Huginn environment files are managed:
  file.managed:
    - names:
      - {{ huginn.lookup.paths.config_huginn }}:
        - source: {{ files_switch(
                        ["huginn.env", "huginn.env.j2"],
                        config=huginn,
                        lookup="huginn environment file is managed",
                        indent_width=10,
                     )
                  }}
      - {{ huginn.lookup.paths.config_db }}:
        - source: {{ files_switch(
                        ["db.env", "db.env.j2"],
                        config=huginn,
                        lookup="db environment file is managed",
                        indent_width=10,
                     )
                  }}
    - mode: '0640'
    - user: root
    - group: {{ huginn.lookup.user.name }}
    - makedirs: true
    - template: jinja
    - require:
      - user: {{ huginn.lookup.user.name }}
    - require_in:
      - Huginn is installed
    - context:
        huginn: {{ huginn | json }}
