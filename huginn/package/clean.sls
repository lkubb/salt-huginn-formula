# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as huginn with context %}

include:
  - {{ sls_config_clean }}

{%- if huginn.install.autoupdate_service %}

Podman autoupdate service is disabled for Huginn:
{%-   if huginn.install.rootless %}
  compose.systemd_service_disabled:
    - user: {{ huginn.lookup.user.name }}
{%-   else %}
  service.disabled:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}

Huginn is absent:
  compose.removed:
    - name: {{ huginn.lookup.paths.compose }}
    - volumes: {{ huginn.install.remove_all_data_for_sure }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if huginn.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ huginn.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if huginn.install.rootless %}
    - user: {{ huginn.lookup.user.name }}
{%- endif %}
    - require:
      - sls: {{ sls_config_clean }}

Huginn compose file is absent:
  file.absent:
    - name: {{ huginn.lookup.paths.compose }}
    - require:
      - Huginn is absent

Huginn user session is not initialized at boot:
  compose.lingering_managed:
    - name: {{ huginn.lookup.user.name }}
    - enable: false
    - onlyif:
      - fun: user.info
        name: {{ huginn.lookup.user.name }}

Huginn user account is absent:
  user.absent:
    - name: {{ huginn.lookup.user.name }}
    - purge: {{ huginn.install.remove_all_data_for_sure }}
    - require:
      - Huginn is absent
    - retry:
        attempts: 5
        interval: 2

{%- if huginn.install.remove_all_data_for_sure %}

Huginn paths are absent:
  file.absent:
    - names:
      - {{ huginn.lookup.paths.base }}
    - require:
      - Huginn is absent
{%- endif %}
