# vim: ft=sls

{#-
    Starts the huginn, db container services
    and enables them at boot time.
    Has a dependency on `huginn.config`_.
#}

include:
  - .running
