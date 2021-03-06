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

include Chef::JenkinsCLI

use_inline_resources

def job_exists?
  res = jenkins_request("job/#{new_resource.job_name}/config.xml")
  res.kind_of?(Net::HTTPSuccess)
end

action :create do
  unless job_exists?
    jenkins_cli "create-job #{new_resource.job_name} < #{new_resource.config}"
  end
end

action :update do
  if job_exists?
    jenkins_post("job/#{new_resource.job_name}/config.xml", IO.read(new_resource.config) )
  else
    jenkins_cli "create-job #{new_resource.job_name} < #{new_resource.config}" do
      private_key new_resource.private_key if new_resource.private_key
    end
  end
end

action :delete do
  jenkins_cli "delete-job #{new_resource.job_name}" do
    private_key new_resource.private_key if new_resource.private_key
  end
end

action :disable do
  jenkins_cli "disable-job #{new_resource.job_name}" do
    private_key new_resource.private_key if new_resource.private_key
  end
end

action :enable do
  jenkins_cli "enable-job #{new_resource.job_name}" do
    private_key new_resource.private_key if new_resource.private_key
  end
end

action :build do
  jenkins_cli "build #{new_resource.job_name}" do
    private_key new_resource.private_key if new_resource.private_key
  end
end
