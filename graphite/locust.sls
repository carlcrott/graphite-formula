
locust-deps:
  pkg.installed:
    - names:
      - python-pip

install-locust:
  cmd.run:
    - name: pip install locustio

/opt/locust/locustfile.py:
  file.managed:
    - makedirs: True
    - source: salt://graphite/files/locustfile.py
