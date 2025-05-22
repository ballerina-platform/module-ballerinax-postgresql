# Copyright (c) 2021, WSO2 Inc. (http://wso2.com) All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM postgres

RUN mkdir -p /etc/ssl
COPY keystore/server/server.crt /etc/ssl/server.crt
COPY keystore/server/server.key /etc/ssl/server.key
COPY keystore/server/root.crt /etc/postgresql/root.crt

RUN chown -R postgres /etc/ssl
RUN chmod -R 0600 /etc/ssl/server.key
RUN chmod -R 0777 /etc/postgresql/root.crt
