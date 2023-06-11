# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as huginn with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

Huginn user account is present:
  user.present:
{%- for param, val in huginn.lookup.user.items() %}
{%-   if val is not none and param != "groups" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - usergroup: true
    - createhome: true
    - groups: {{ huginn.lookup.user.groups | json }}
    # (on Debian 11) subuid/subgid are only added automatically for non-system users
    - system: false

Huginn user session is initialized at boot:
  compose.lingering_managed:
    - name: {{ huginn.lookup.user.name }}
    - enable: {{ huginn.install.rootless }}
    - require:
      - user: {{ huginn.lookup.user.name }}

Huginn paths are present:
  file.directory:
    - names:
      - {{ huginn.lookup.paths.base }}
    - user: {{ huginn.lookup.user.name }}
    - group: {{ huginn.lookup.user.name }}
    - makedirs: true
    - require:
      - user: {{ huginn.lookup.user.name }}

{%- if huginn.install.podman_api %}

Huginn podman API is enabled:
  compose.systemd_service_enabled:
    - name: podman.socket
    - user: {{ huginn.lookup.user.name }}
    - require:
      - Huginn user session is initialized at boot

Huginn podman API is available:
  compose.systemd_service_running:
    - name: podman.socket
    - user: {{ huginn.lookup.user.name }}
    - require:
      - Huginn user session is initialized at boot
{%- endif %}

Huginn compose file is managed:
  file.managed:
    - name: {{ huginn.lookup.paths.compose }}
    - source: {{ files_switch(
                    ["docker-compose.yml", "docker-compose.yml.j2"],
                    config=huginn,
                    lookup="Huginn compose file is present",
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ huginn.lookup.rootgroup }}
    - makedirs: true
    - template: jinja
    - makedirs: true
    - context:
        huginn: {{ huginn | json }}

Huginn is installed:
  compose.installed:
    - name: {{ huginn.lookup.paths.compose }}
{%- for param, val in huginn.lookup.compose.items() %}
{%-   if val is not none and param != "service" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
{%- for param, val in huginn.lookup.compose.service.items() %}
{%-   if val is not none %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - watch:
      - file: {{ huginn.lookup.paths.compose }}
{%- if huginn.install.rootless %}
    - user: {{ huginn.lookup.user.name }}
    - require:
      - user: {{ huginn.lookup.user.name }}
{%- endif %}

{%- if huginn.install.autoupdate_service is not none %}

Podman autoupdate service is managed for Huginn:
{%-   if huginn.install.rootless %}
  compose.systemd_service_{{ "enabled" if huginn.install.autoupdate_service else "disabled" }}:
    - user: {{ huginn.lookup.user.name }}
{%-   else %}
  service.{{ "enabled" if huginn.install.autoupdate_service else "disabled" }}:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}
