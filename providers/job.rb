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

def server_url
  new_resource.url || node[:jenkins][:server][:url]
end

def job_url
  job_url = "#{server_url}/job/#{new_resource.job_name}/config.xml"
  Chef::Log.debug "[jenkins_job] job_url: #{job_url}"
  job_url
end

def job_exists
  url = URI.parse(job_url)
  res = Chef::REST::RESTRequest.new(:GET, url, nil).call
  Chef::Log.debug("[jenkins_job] GET #{url.request_uri} == #{res.code}")
  res.kind_of?(Net::HTTPSuccess)
end

notifying_action :create do
  unless job_exists
    jenkins_cli "create-job #{new_resource.job_name} < #{new_resource.config}"
  end
end

notifying_action :update do
  if job_exists
    jenkins_cli "update-job #{new_resource.job_name} < #{new_resource.config}"
  else
    jenkins_cli "create-job #{new_resource.job_name} < #{new_resource.config}"
  end
end

notifying_action :delete do
  jenkins_cli "delete-job #{new_resource.job_name}"
end

notifying_action :disable do
  jenkins_cli "disable-job #{new_resource.job_name}"
end

notifying_action :enable do
  jenkins_cli "enable-job #{new_resource.job_name}"
end

notifying_action :build do
  jenkins_cli "build #{new_resource.job_name}"
end
