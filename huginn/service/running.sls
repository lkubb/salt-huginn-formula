# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as huginn with context %}

include:
  - {{ sls_config_file }}

Huginn service is enabled:
  compose.enabled:
    - name: {{ huginn.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if huginn.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ huginn.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
    - require:
      - Huginn is installed
{%- if huginn.install.rootless %}
    - user: {{ huginn.lookup.user.name }}
{%- endif %}

Huginn service is running:
  compose.running:
    - name: {{ huginn.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if huginn.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ huginn.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if huginn.install.rootless %}
    - user: {{ huginn.lookup.user.name }}
{%- endif %}
    - watch:
      - Huginn is installed
      - sls: {{ sls_config_file }}
