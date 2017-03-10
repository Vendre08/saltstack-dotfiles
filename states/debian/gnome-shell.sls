requirements:
  pkg.installed:
    - pkgs:
      - gnome-common
        
{% for extension in [
  { "uuid": "TopIcons@phocean.net",
    "repository": "https://github.com/phocean/TopIcons-plus.git",
    "command": "make install"
  },
  { "uuid": "pixel-saver@deadalnix.me",
    "repository": "https://github.com/deadalnix/pixel-saver.git",
    "command": "cp -r pixel-saver@deadalnix.me -t ~/.local/share/gnome-shell/extensions"
  },
  { "uuid": "focus-my-window@varianto25.com",
    "repository": "https://github.com/v-dimitrov/gnome-shell-extension-stealmyfocus",
    "command": "rsync --recursive * ~/.local/share/gnome-shell/extensions/focus-my-window@varianto25.com/"
  },
  { "uuid": "dynamicTopBar@gnomeshell.feildel.fr",
    "repository": "https://github.com/AMDG2/GnomeShell_DynamicTopBar.git",
    "command": "cp -r dynamicTopBar@gnomeshell.feildel.fr ~/.local/share/gnome-shell/extensions/"
  },
  {
    "uuid": "panel-osd@berend.de.schouwer.gmail.com",
    "repository": "https://github.com/jenslody/gnome-shell-extension-panel-osd.git",
    "command": "./autogen.sh && make local-install"
  },
  { "uuid": "dash-to-dock@micxgx.gmail.com",
    "repository": "https://github.com/micheleg/dash-to-dock.git",
    "command": "make install"
  },
  { "uuid": "caffeine@patapon.info",
    "repository": "https://github.com/eonpatapon/gnome-shell-extension-caffeine.git",
    "command": "./update-locale.sh && glib-compile-schemas --strict --targetdir=caffeine@patapon.info/schemas/ caffeine@patapon.info/schemas \
      && cp -r caffeine@patapon.info ~/.local/share/gnome-shell/extensions"
  },
  {
    "uuid": "gravatar@jr.rlabs.io",
    "repository": "https://github.com/jrouleau/gnome-shell-extension-gravatar.git",
    "command": "npm install && npm run install-extension"
  }
] %}

{{ extension.uuid }}-clone:
  git.latest:
    - name: {{ extension.repository }}
    - target: {{ grains.homedir }}/.gnome-shell-extensions/{{ extension.uuid }}
    - depth: 1
    - force_reset: True
    - user: {{ grains.user }}

{{ extension.uuid }}-install:
  cmd.run:
    - name: {{ extension.command }}
    - user: {{ grains.user }}
    - cwd: {{ grains.homedir }}/.gnome-shell-extensions/{{ extension.uuid }}

{{ extension.uuid }}-enable:
  cmd.run:
    - name: gnome-shell-extension-tool -e {{ extension.uuid }}
    - user: {{ grains.user }}
    - onfail:
      - cmd: skip

{% endfor %}

enable-user-themes:
  cmd.run:
    - name: gnome-shell-extension-tool -e 'user-theme@gnome-shell-extensions.gcampax.github.com'
    - onfail:
      - cmd: skip

skip:
  cmd.run:
    - name: echo "Already enabled"
