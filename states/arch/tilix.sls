{% from './aur.sls' import aur with context %}

{{ aur('tilix-bin') }}
