#
# Copyright (c) 2017 Make.org
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

cookbook_name = 'chrony-ntp'

# Where to put the exporter script
default[cookbook_name]['exporter_dir'] = '/opt/prometheus_chrony'
exporter_file = "#{node[cookbook_name]['exporter_dir']}/chrony_exporter.sh"

# Where to put the exported metrics
default[cookbook_name]['metrics_dir'] = '/opt/prometheus_metrics'
metrics_file = "#{node[cookbook_name]['metrics_dir']}/chronyd.prom"

# Systemd service unit
default[cookbook_name]['systemd_unit'] = {
  'Unit' => {
    'Description' => 'Chrony exporter service',
    'After' => 'network.target'
  },
  'Service' => {
    'Type' => 'simple',
    'ExecStart' => "/bin/bash -c '#{exporter_file} > #{metrics_file}'"
  }
}

# Systemd timer unit
default[cookbook_name]['systemd_timer_unit'] = {
  'Unit' => {
    'Description' => 'Chrony exporter timer'
  },
  'Timer' => {
    'OnCalendar' => '*:0/5'
  },
  'Install' => {
    'WantedBy' => 'timers.target'
  }
}
