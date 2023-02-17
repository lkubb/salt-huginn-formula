Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``huginn``
^^^^^^^^^^
*Meta-state*.

This installs the huginn, db containers,
manages their configuration and starts their services.


``huginn.package``
^^^^^^^^^^^^^^^^^^
Installs the huginn, db containers only.
This includes creating systemd service units.


``huginn.config``
^^^^^^^^^^^^^^^^^
Manages the configuration of the huginn, db containers.
Has a dependency on `huginn.package`_.


``huginn.service``
^^^^^^^^^^^^^^^^^^
Starts the huginn, db container services
and enables them at boot time.
Has a dependency on `huginn.config`_.


``huginn.clean``
^^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``huginn`` meta-state
in reverse order, i.e. stops the huginn, db services,
removes their configuration and then removes their containers.


``huginn.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^
Removes the huginn, db containers
and the corresponding user account and service units.
Has a depency on `huginn.config.clean`_.
If ``remove_all_data_for_sure`` was set, also removes all data.


``huginn.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the huginn, db containers
and has a dependency on `huginn.service.clean`_.

This does not lead to the containers/services being rebuilt
and thus differs from the usual behavior.


``huginn.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^
Stops the huginn, db container services
and disables them at boot time.


