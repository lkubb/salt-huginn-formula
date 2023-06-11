# vim: ft=sls

{#-
    Stops the huginn, db container services
    and disables them at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as huginn with context %}

huginn service is dead:
  compose.dead:
    - name: {{ huginn.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if huginn.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ huginn.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if huginn.install.rootless %}
    - user: {{ huginn.lookup.user.name }}
{%- endif %}

huginn service is disabled:
  compose.disabled:
    - name: {{ huginn.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if huginn.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ huginn.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if huginn.install.rootless %}
    - user: {{ huginn.lookup.user.name }}
{%- endif %}
