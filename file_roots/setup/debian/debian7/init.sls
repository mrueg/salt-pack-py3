{% set os_codename = 'wheezy' %}
{% set prefs_text = 'Package: *
        Pin: release a=' ~ os_codename ~ '-updates
        Pin-Priority: 770
        Package: *
        Pin: release a=' ~ os_codename ~ '-backports
        Pin-Priority: 750
        Package: *
        Pin: release a=' ~ os_codename ~ '
        Pin-Priority: 720
        Package: *
        Pin: release a=oldstable
        Pin-Priority: 700
' %}

include:
  - setup.debian

build_pbldhooks_file:
  file.append:
    - name: /root/.pbuilder-hooks/G05apt-preferences
    - makedirs: True
    - text: |
        #!/bin/sh
        set -e
        cat > "/etc/apt/preferences" << EOF
        {{prefs_text}}
        EOF


build_pbldhooks_perms:
  file.directory:
    - name: /root/.pbuilder-hooks/
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755
    - recurse:
        - user
        - group
        - mode


build_pbldrc:
  file.append:
    - name: /root/.pbuilderrc
    - text: |
        DIST="{{os_codename}}"
        if [ -n "${DIST}" ]; then
          TMPDIR=/tmp
          BASETGZ="`dirname $BASETGZ`/${DIST}-base.tgz"
          DISTRIBUTION=${DIST}
          APTCACHE="/var/cache/pbuilder/${DIST}/aptcache"
        fi
        HOOKDIR="${HOME}/.pbuilder-hooks"
        OTHERMIRROR="deb http://ftp.us.debian.org/debian/ {{os_codename}}-updates main contrib | deb http://ftp.us.debian.org/debian/ {{os_codename}}-backports main contrib | deb http://ftp.us.debian.org/debian/ oldstable main contrib "


build_prefs:
  file.append:
    - name: /etc/apt/preferences
    - text: |
        {{prefs_text}}
