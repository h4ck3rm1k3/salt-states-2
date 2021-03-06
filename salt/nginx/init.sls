# manage nginx config
nginxconf:
  file.managed:
    - name: /etc/nginx/sites-available/{{ pillar['project']['name'] }}
    - source: salt://nginx/nginx.conf
    - template: jinja
    - makedirs: True

# create symlink of nginx config
nginxconf_symlink:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ pillar['project']['name'] }}
    - target: /etc/nginx/sites-available/{{ pillar['project']['name'] }}
    - makedirs: True
    - force: True

# install and run nginx service
nginx:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: nginxconf

# change nginx log permissions
/var/log/nginx:
  file.directory:
    - group: {{ pillar['system']['web_group'] }}
    - user: {{ pillar['system']['web_user'] }}
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - group
      - user
      - mode
