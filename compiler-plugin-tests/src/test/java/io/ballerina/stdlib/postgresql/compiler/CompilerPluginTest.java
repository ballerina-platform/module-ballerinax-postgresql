/*
 * Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.postgresql.compiler;

import io.ballerina.projects.DiagnosticResult;
import io.ballerina.projects.Package;
import io.ballerina.projects.PackageCompilation;
import io.ballerina.projects.ProjectEnvironmentBuilder;
import io.ballerina.projects.directory.BuildProject;
import io.ballerina.projects.environment.Environment;
import io.ballerina.projects.environment.EnvironmentBuilder;
import io.ballerina.tools.diagnostics.Diagnostic;
import io.ballerina.tools.diagnostics.DiagnosticInfo;
import io.ballerina.tools.diagnostics.DiagnosticSeverity;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

import static io.ballerina.stdlib.postgresql.compiler.PostgreSQLDiagnosticsCode.POSTGRESQL_101;
import static io.ballerina.stdlib.postgresql.compiler.PostgreSQLDiagnosticsCode.POSTGRESQL_102;
import static io.ballerina.stdlib.postgresql.compiler.PostgreSQLDiagnosticsCode.POSTGRESQL_201;
import static io.ballerina.stdlib.postgresql.compiler.PostgreSQLDiagnosticsCode.POSTGRESQL_202;
import static io.ballerina.stdlib.postgresql.compiler.PostgreSQLDiagnosticsCode.POSTGRESQL_203;
import static io.ballerina.stdlib.postgresql.compiler.PostgreSQLDiagnosticsCode.POSTGRESQL_204;
import static io.ballerina.stdlib.postgresql.compiler.PostgreSQLDiagnosticsCode.POSTGRESQL_903;
import static io.ballerina.stdlib.postgresql.compiler.PostgreSQLDiagnosticsCode.SQL_101;

/**
 * Tests the custom SQL compiler plugin.
 */
public class CompilerPluginTest {

    private static final Path RESOURCE_DIRECTORY = Paths.get("src", "test", "resources", "diagnostics")
            .toAbsolutePath();
    private static final Path DISTRIBUTION_PATH = Paths.get("../", "target", "ballerina-runtime")
            .toAbsolutePath();

    private static ProjectEnvironmentBuilder getEnvironmentBuilder() {
        Environment environment = EnvironmentBuilder.getBuilder().setBallerinaHome(DISTRIBUTION_PATH).build();
        return ProjectEnvironmentBuilder.getBuilder(environment);
    }

    private Package loadPackage(String path) {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve(path);
        BuildProject project = BuildProject.load(getEnvironmentBuilder(), projectDirPath);
        return project.currentPackage();
    }

    @Test
    public void testFunctionHints() {
        Package currentPackage = loadPackage("sample1");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        long availableErrors = diagnosticResult.diagnostics().stream()
                .filter(r -> r.diagnosticInfo().severity().equals(DiagnosticSeverity.ERROR)).count();
        Assert.assertEquals(availableErrors, 3);

        List<Diagnostic> diagnosticHints = diagnosticResult.diagnostics().stream()
                .filter(r -> r.diagnosticInfo().severity().equals(DiagnosticSeverity.HINT))
                .collect(Collectors.toList());
        long availableHints = diagnosticHints.size();
        Assert.assertEquals(availableHints, 3);

        DiagnosticInfo hint1 = diagnosticHints.get(0).diagnosticInfo();
        Assert.assertEquals(hint1.code(), PostgreSQLDiagnosticsCode.POSTGRESQL_901.getCode());
        Assert.assertEquals(hint1.messageFormat(), PostgreSQLDiagnosticsCode.POSTGRESQL_901.getMessage());

        DiagnosticInfo hint2 = diagnosticHints.get(1).diagnosticInfo();
        Assert.assertEquals(hint2.code(), PostgreSQLDiagnosticsCode.POSTGRESQL_902.getCode());
        Assert.assertEquals(hint2.messageFormat(), PostgreSQLDiagnosticsCode.POSTGRESQL_902.getMessage());

        DiagnosticInfo hint3 = diagnosticHints.get(2).diagnosticInfo();
        Assert.assertEquals(hint3.code(), PostgreSQLDiagnosticsCode.POSTGRESQL_901.getCode());
        Assert.assertEquals(hint3.messageFormat(), PostgreSQLDiagnosticsCode.POSTGRESQL_901.getMessage());
    }

    @Test
    public void testSQLConnectionPoolFieldsInNewExpression() {
        Package currentPackage = loadPackage("sample2");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        List<Diagnostic> diagnosticErrorStream = diagnosticResult.diagnostics().stream()
                .filter(r -> r.diagnosticInfo().severity().equals(DiagnosticSeverity.ERROR))
                .collect(Collectors.toList());
        long availableErrors = diagnosticErrorStream.size();

        Assert.assertEquals(availableErrors, 5);

        for (int i = 0; i < diagnosticErrorStream.size(); i++) {
            Diagnostic diagnostic = diagnosticErrorStream.get(i);
            switch (i) {
                case 0:
                case 3:
                case 4:
                    Assert.assertEquals(diagnostic.diagnosticInfo().code(), POSTGRESQL_101.getCode());
                    Assert.assertEquals(diagnostic.diagnosticInfo().messageFormat(),
                            POSTGRESQL_101.getMessage());
                    break;
                default:
                    Assert.assertEquals(diagnostic.diagnosticInfo().code(), SQL_101.getCode());
                    Assert.assertEquals(diagnostic.diagnosticInfo().messageFormat(),
                            SQL_101.getMessage());
            }
        }
    }

    @Test
    public void testPostgreSQLOptionRecord() {
        Package currentPackage = loadPackage("sample3");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        List<Diagnostic> diagnosticErrorStream = diagnosticResult.diagnostics().stream()
                .filter(r -> r.diagnosticInfo().severity().equals(DiagnosticSeverity.ERROR))
                .collect(Collectors.toList());
        long availableErrors = diagnosticErrorStream.size();

        Assert.assertEquals(availableErrors, 14);

        for (int i = 0; i < diagnosticErrorStream.size(); i++) {
            Diagnostic diagnostic = diagnosticErrorStream.get(i);
            if (i <= 7) {
                Assert.assertEquals(diagnostic.diagnosticInfo().code(), POSTGRESQL_101.getCode());
                Assert.assertEquals(diagnostic.diagnosticInfo().messageFormat(),
                        POSTGRESQL_101.getMessage());
            } else {
                Assert.assertEquals(diagnostic.diagnosticInfo().code(), POSTGRESQL_102.getCode());
                Assert.assertEquals(diagnostic.diagnosticInfo().messageFormat(),
                        POSTGRESQL_102.getMessage());
            }
        }
    }

    @Test
    public void testOutParameterValidations() {
        Package currentPackage = loadPackage("sample4");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        List<Diagnostic> errorDiagnosticsList = diagnosticResult.diagnostics().stream()
                .filter(r -> r.diagnosticInfo().severity().equals(DiagnosticSeverity.ERROR))
                .collect(Collectors.toList());
        long availableErrors = errorDiagnosticsList.size();

        Assert.assertEquals(availableErrors, 4);

        DiagnosticInfo diagnostic = errorDiagnosticsList.get(0).diagnosticInfo();
        Assert.assertEquals(diagnostic.code(), POSTGRESQL_201.getCode());
        Assert.assertEquals(diagnostic.messageFormat(), POSTGRESQL_201.getMessage());

        diagnostic = errorDiagnosticsList.get(1).diagnosticInfo();
        Assert.assertEquals(diagnostic.code(), POSTGRESQL_202.getCode());
        Assert.assertEquals(diagnostic.messageFormat(), POSTGRESQL_202.getMessage());

        diagnostic = errorDiagnosticsList.get(2).diagnosticInfo();
        Assert.assertEquals(diagnostic.code(), POSTGRESQL_203.getCode());
        Assert.assertEquals(diagnostic.messageFormat(), POSTGRESQL_203.getMessage());

        diagnostic = errorDiagnosticsList.get(3).diagnosticInfo();
        Assert.assertEquals(diagnostic.code(), POSTGRESQL_204.getCode());
        Assert.assertEquals(diagnostic.messageFormat(), POSTGRESQL_204.getMessage());
    }

    @Test
    public void testOutParameterHint() {
        Package currentPackage = loadPackage("sample5");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        List<Diagnostic> errorDiagnosticsList = diagnosticResult.diagnostics().stream()
                .filter(r -> r.diagnosticInfo().severity().equals(DiagnosticSeverity.ERROR))
                .collect(Collectors.toList());
        long availableErrors = errorDiagnosticsList.size();

        Assert.assertEquals(availableErrors, 1);

        List<Diagnostic> hintDiagnosticsList = diagnosticResult.diagnostics().stream()
                .filter(r -> r.diagnosticInfo().severity().equals(DiagnosticSeverity.HINT))
                .collect(Collectors.toList());
        long availableHints = hintDiagnosticsList.size();

        Assert.assertEquals(availableHints, 1);

        hintDiagnosticsList.forEach(diagnostic -> {
            Assert.assertEquals(diagnostic.diagnosticInfo().code(), POSTGRESQL_903.getCode());
            Assert.assertEquals(diagnostic.diagnosticInfo().messageFormat(), POSTGRESQL_903.getMessage());
        });

    }
}
