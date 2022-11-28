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

ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD postgres

COPY sql-scripts/init-scripts/database-init-script.sql /docker-entrypoint-initdb.d/01-database-init-script.sql

COPY sql-scripts/init-scripts/table-init-script.sql /docker-entrypoint-initdb.d/02-table-init-script.sql

COPY sql-scripts/connection-pool/connection-pool1-test.sql /docker-entrypoint-initdb.d/03-connection-pool1-test.sql

COPY sql-scripts/connection-pool/connection-pool2-test.sql /docker-entrypoint-initdb.d/04-connection-pool2-test.sql

COPY sql-scripts/local-transaction/local-transaction-test.sql /docker-entrypoint-initdb.d/05-local-transaction-test.sql

COPY sql-scripts/procedures/procedures-test-data.sql /docker-entrypoint-initdb.d/06-procedures-test-data.sql

COPY sql-scripts/functions/function-test-data.sql /docker-entrypoint-initdb.d/07-function-test-data.sql

COPY sql-scripts/error/error-test-data.sql /docker-entrypoint-initdb.d/08-error-test-data.sql

COPY sql-scripts/schema/schema-client-test-data.sql /docker-entrypoint-initdb.d/

RUN mkdir -p /etc/ssl
COPY keystore/server/server.crt /etc/ssl/server.crt
COPY keystore/server/server.key /etc/ssl/server.key
COPY keystore/server/root.crt /etc/postgresql/root.crt

RUN chown -R postgres /etc/ssl
RUN chmod -R 0600 /etc/ssl/server.key
RUN chmod -R 0777 /etc/postgresql/root.crt
