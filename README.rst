elrepo
====

Install the ELRepo RPM and GPG key on RHEL 5/6/7, CentOS 5/6/7, or Oracle Linux 5/6/7.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``elrepo``
--------

Installs the GPG key and ELRepo RPM package for the current OS.

Credit
================

This is pretty much the `SaltStack epel-formula 
<https://github.com/saltstack-formulas/epel-formula>`_, except with elrepo swapped for epel.
