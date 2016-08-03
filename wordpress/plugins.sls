{% from "wordpress/map.jinja" import map with context %}
{% for site in pillar['wordpress']['sites'] %}
{% for plugin in pillar['wordpress']['sites'][site]['plugins'] %}

# This command tells wp-cli to install plugin if not already installed
install_{{ plugin }}:
  cmd.run:
    - name: '/usr/local/bin/wp plugin install {{ plugin }}'
    - cwd: {{ map.docroot }}/{{ site }}
    - user: www-data
    - unless: '/usr/local/bin/wp plugin is-installed {{ plugin }}'

# This command tells wp-cli to activate plugin if not already active
activate_{{ plugin  }}:
  cmd.run:
    - name: '/usr/local/bin/wp plugin activate {{ plugin }}'
    - cwd: {{ map.docroot }}/{{ site }}
    - user: www-data
    - unless: "/usr/local/bin/wp plugin status {{ plugin }} | grep -q 'Status: Active'"

{% endfor %}
{% endfor %}
