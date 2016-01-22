# Completely ignore non-RHEL based systems
{% if grains['os_family'] == 'RedHat' %}

# A lookup table for ELRepo GPG keys & RPM URLs for various RedHat releases
{% if grains['osmajorrelease'][0] == '5' %}
  {% set pkg= {
    'key': 'https://www.elrepo.org/RPM-GPG-KEY-elrepo.org',
    'key_hash': 'sha256=3ff72dc42e94c16844e87090026af35184e459c6a516d3ebcae2a77b896fdd57',
    'rpm': 'https://http://www.elrepo.org/elrepo-release-5-5.el5.elrepo.noarch.rpm',
  } %}
{% elif grains['osmajorrelease'][0] == '6' %}
  {% set pkg= {
    'key': 'https://www.elrepo.org/RPM-GPG-KEY-elrepo.org',
    'key_hash': 'sha256=3ff72dc42e94c16844e87090026af35184e459c6a516d3ebcae2a77b896fdd57',
    'rpm': 'http://www.elrepo.org/elrepo-release-6-6.el6.elrepo.noarch.rpm',
  } %}
{% elif grains['osmajorrelease'][0] == '7' %}
  {% set pkg= {
    'key': 'https://www.elrepo.org/RPM-GPG-KEY-elrepo.org',
    'key_hash': 'sha256=3ff72dc42e94c16844e87090026af35184e459c6a516d3ebcae2a77b896fdd57',
    'rpm': 'http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm',
  } %}
{% endif %}


install_pubkey_elrepo:
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-elrepo.org
    - source: {{ salt['pillar.get']('elrepo:pubkey', pkg.key) }}
    - source_hash:  {{ salt['pillar.get']('elrepo:pubkey_hash', pkg.key_hash) }}


elrepo_release:
  pkg.installed:
    - sources:
      - elrepo-release: {{ salt['pillar.get']('elrepo:rpm', pkg.rpm) }}
    - require:
      - file: install_pubkey_elrepo

set_pubkey_elrepo:
  file.replace:
    - append_if_not_found: True
    - name: /etc/yum.repos.d/elrepo.repo
    - pattern: '^gpgkey=.*'
    - repl: 'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-elrepo.org'
    - require:
      - pkg: elrepo_release

set_gpg_elrepo:
  file.replace:
    - append_if_not_found: True
    - name: /etc/yum.repos.d/elrepo.repo
    - pattern: 'gpgcheck=.*'
    - repl: 'gpgcheck=1'
    - require:
      - pkg: elrepo_release

{% if salt['pillar.get']('elrepo:disabled', False) %}
disable_elrepo:
  pkgrepo.managed:
    - name: elrepo
    - disabled: true
{% else %}
enable_elrepo:
  pkgrepo.managed:
    - name: elrepo
    - disabled: false
{% endif %}
{% endif %}
