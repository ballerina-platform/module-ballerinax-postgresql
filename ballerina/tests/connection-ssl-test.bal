// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/file;
import ballerina/lang.'string as strings;
import ballerina/sql;
import ballerina/test;

string clientkeyPath = check file:getAbsolutePath("./tests/resources/keystore/client/postgresql.pfx");
string clientkeyPath2 = check file:getAbsolutePath("./tests/resources/keystore/client/postgresql.pk8");
string clientCertPath = check file:getAbsolutePath("./tests/resources/keystore/client/postgresql.crt");
string serverCertPath = check file:getAbsolutePath("./tests/resources/keystore/server/root.crt");
string sslPassword = "changeit";

@test:Config {
    groups: ["connection", "ssl"]
}
function testSSLRequireWithPfxKey() returns error? {
    Options options = {
        ssl: {
            mode: REQUIRE,
            rootcert: serverCertPath,
            key: {
                path: clientkeyPath,
                password: sslPassword
            }
        }
    };
    Client dbClient = check new (username = user, password = password, database = sslDb, 
        port = sslPort, options = options);
    test:assertEquals(dbClient.close(), ());
}

@test:Config {
    groups: ["connection", "ssl"]
}
function testSSLRequireWithSslCert() returns error? {
    Options options = {
        ssl: {
            mode: REQUIRE,
            rootcert: serverCertPath,
            key: {
                certFile: clientCertPath,
                keyFile: clientkeyPath2,
                keyPassword: sslPassword
            }
        }
    };
    Client dbClient = check new (username = user, password = password, database = sslDb, 
        port = sslPort, options = options);
    test:assertEquals(dbClient.close(), ());
}

@test:Config {
    groups: ["connection", "ssl"]
}
function testSSLPreferWithPfxKey() returns error? {
    Options options = {
        ssl: {
            mode: PREFER,
            rootcert: serverCertPath,
            key: {
                path: clientkeyPath,
                password: sslPassword
            }
        }
    };
    Client dbClient = check new (username = user, password = password, database = sslDb, 
        port = sslPort, options = options);
    test:assertEquals(dbClient.close(), ());
}

@test:Config {
    groups: ["connection", "ssl"]
}
function testSSLPreferWithSslCert() returns error? {
    Options options = {
        ssl: {
            mode: PREFER,
            rootcert: serverCertPath,
            key: {
                certFile: clientCertPath,
                keyFile: clientkeyPath2,
                keyPassword: sslPassword
            }
        }
    };
    Client dbClient = check new (username = user, password = password, database = sslDb, 
        port = sslPort, options = options);
    test:assertEquals(dbClient.close(), ());
}

@test:Config {
    groups: ["connection", "ssl"]
}
function testSSLAllowWithPfxKey() returns error? {
    Options options = {
        ssl: {
            mode: ALLOW,
            rootcert: serverCertPath,
            key: {
                path: clientkeyPath,
                password: sslPassword
            }
        }
    };
    Client dbClient = check new (username = user, password = password, database = sslDb, 
        port = sslPort, options = options);
    test:assertEquals(dbClient.close(), ());
}

@test:Config {
    groups: ["connection", "ssl"]
}
function testSSLAllowWithSslCert() returns error? {
    Options options = {
        ssl: {
            mode: ALLOW,
            rootcert: serverCertPath,
            key: {
                certFile: clientCertPath,
                keyFile: clientkeyPath2,
                keyPassword: sslPassword
            }
        }
    };
    Client dbClient = check new (username = user, password = password, database = sslDb, 
        port = sslPort, options = options);
    test:assertEquals(dbClient.close(), ());
}

@test:Config {
    groups: ["connection", "ssl"]
}
function testSSLDisable() returns error? {
    Options options = {
        ssl: {
            mode: DISABLE
        }
    };
    Client dbClient = check new (username = user, password = password, database = sslDb, 
        port = sslPort, options = options);
    test:assertEquals(dbClient.close(), ());
}

@test:Config {
    groups: ["connection", "ssl"]
}
function testSSLVerifyCertWithPfxKey() returns error? {
    Options options = {
        ssl: {
            mode: VERIFY_CA,
            rootcert: serverCertPath,
            key: {
                path: clientkeyPath,
                password: sslPassword
            }
        }
    };
    Client dbClient = check new (username = user, password = password, database = sslDb, 
        port = sslPort, options = options);
    test:assertEquals(dbClient.close(), ());
}

@test:Config {
    groups: ["connection", "ssl"]
}
function testSSLVerifyCertWithSslCert() returns error? {
    Options options = {
        ssl: {
            mode: VERIFY_CA,
            rootcert: serverCertPath,
            key: {
                certFile: clientCertPath,
                keyFile: clientkeyPath2,
                keyPassword: sslPassword
            }
        }
    };
    Client dbClient = check new (username = user, password = password, database = sslDb, 
        port = sslPort, options = options);
    test:assertEquals(dbClient.close(), ());
}

@test:Config {
    groups: ["connection", "ssl"]
}
function testSSLVerifyFullWithPfxKey() returns error? {
    Options options = {
        ssl: {
            mode: VERIFY_FULL,
            rootcert: serverCertPath,
            key: {
                path: clientkeyPath,
                password: sslPassword
            }
        }
    };
    Client|sql:Error dbClient = new (username = user, password = password, database = sslDb, 
        port = sslPort, options = options);
    test:assertTrue(dbClient is error);
    error dbError = <error>dbClient;
    test:assertTrue(strings:includes(dbError.message(), "The hostname localhost could not be verified"));
}

@test:Config {
    groups: ["connection", "ssl"]
}
function testSSLVerifyFullWithSslCert() returns error? {
    Options options = {
        ssl: {
            mode: VERIFY_FULL,
            rootcert: serverCertPath,
            key: {
                certFile: clientCertPath,
                keyFile: clientkeyPath2,
                keyPassword: sslPassword
            }
        }
    };
    Client|sql:Error dbClient = new (username = user, password = password, database = sslDb, 
        port = sslPort, options = options);
    test:assertTrue(dbClient is error);
    error dbError = <error>dbClient;
    test:assertTrue(strings:includes(dbError.message(), "The hostname localhost could not be verified"));
}

@test:Config {
    groups: ["connection", "ssl"]
}
function testSSLWithEmptyRecord() returns error? {
    Options options = {
        ssl: {}
    };
    Client dbClient = check new (username = user, password = password, database = sslDb, 
        port = sslPort, options = options);
    test:assertEquals(dbClient.close(), ());
}
