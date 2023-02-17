# vim: ft=sls

{#-
    Removes the configuration of the huginn, db containers
    and has a dependency on `huginn.service.clean`_.

    This does not lead to the containers/services being rebuilt
    and thus differs from the usual behavior.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as huginn with context %}

include:
  - {{ sls_service_clean }}

Huginn environment files are absent:
  file.absent:
    - names:
      - {{ huginn.lookup.paths.config_huginn }}
      - {{ huginn.lookup.paths.config_db }}
      - {{ huginn.lookup.paths.base | path_join(".saltcache.yml") }}
    - require:
      - sls: {{ sls_service_clean }}
