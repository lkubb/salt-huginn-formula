# vim: ft=yaml
---
huginn:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    compose:
      create_pod: null
      pod_args: null
      project_name: huginn
      remove_orphans: true
      build: false
      build_args: null
      pull: false
      service:
        container_prefix: null
        ephemeral: true
        pod_prefix: null
        restart_policy: on-failure
        restart_sec: 2
        separator: null
        stop_timeout: null
    paths:
      base: /opt/containers/huginn
      compose: docker-compose.yml
      config_huginn: huginn.env
      config_db: db.env
      db: db
    user:
      groups: []
      home: null
      name: huginn
      shell: /usr/sbin/nologin
      uid: null
      gid: null
    containers:
      db:
        image: docker.io/library/mariadb
      huginn:
        image: ghcr.io/huginn/huginn:latest
  install:
    rootless: true
    autoupdate: true
    autoupdate_service: false
    remove_all_data_for_sure: false
    podman_api: true
  config:
    additional_gems: []
    agent_log_length: 200
    allow_unconfirmed_access_for: 2.days
    app_secret_token: null
    asset_host: null
    aws:
      access_key: null
      access_key_id: null
      sandbox: false
    capistrano:
      deploy_repo_url: null
      deploy_server: null
      deploy_user: null
    confirm_within: 3.days
    database:
      adapter: mysql2
      encoding: utf8mb4
      host: db
      name: huginn
      password: null
      pool: 20
      port: 3306
      reconnect: true
      socket: null
      username: huginn
    default_http_user_agent: Huginn - https://github.com/huginn/huginn
    default_scenario_file: null
    delayed_job_max_runtime: 2
    delayed_job_sleep_delay: 10
    diagram_default_layout: dot
    do_not_create_database: true
    domain: localhost:6144
    dropbox:
      oauth_key: null
      oauth_secret: null
    email_from_address: from_address@gmail.com
    enable_insecure_agents: false
    enable_second_precision_schedule: false
    event_expiration_check: 6h
    evernote:
      oauth_key: null
      oauth_secret: null
    failed_jobs_to_keep: 100
    faraday_http_backend: typhoeus
    force_ssl: false
    github:
      oauth_key: null
      oauth_secret: null
    google_client:
      id: null
      secret: null
    import_default_scenario_for_all_users: false
    invitation_code: null
    lock_strategy: failed_attempts
    max_failed_login_attempts: 10
    min_password_length: 8
    port: 6144
    rails_env: production
    remember_for: 4.weeks
    require_confirmed_email: false
    reset_password_within: 6.hours
    scheduler_frequency: 0.3
    send_email_in_development: false
    skip_invitation_code: false
    smtp:
      authentication: plain
      delivery_method: null
      domain: your-domain-here.com
      enable_starttls_auto: true
      password: somepassword
      port: 587
      server: smtp.gmail.com
      ssl: false
      user_name: you@gmail.com
    thirty_seven_signals:
      oauth_key: null
      oauth_secret: null
    timezone: Pacific Time (US & Canada)
    tumblr:
      oauth_key: null
      oauth_secret: null
    twitter:
      oauth_key: null
      oauth_secret: null
    unlock_after: 1.hour
    unlock_strategy: both
    use_evernote_sandbox: false
    use_graphviz_dot: dot
    use_jq: jq

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://huginn/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   huginn-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      Huginn environment file is managed:
      - huginn.env.j2

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
