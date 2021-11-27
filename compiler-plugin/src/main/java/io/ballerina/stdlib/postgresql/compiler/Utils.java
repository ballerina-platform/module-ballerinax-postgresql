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

import io.ballerina.compiler.api.symbols.ModuleSymbol;
import io.ballerina.compiler.api.symbols.TypeDescKind;
import io.ballerina.compiler.api.symbols.TypeReferenceTypeSymbol;
import io.ballerina.compiler.api.symbols.TypeSymbol;
import io.ballerina.compiler.api.symbols.UnionTypeSymbol;
import io.ballerina.compiler.syntax.tree.BasicLiteralNode;
import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.MappingConstructorExpressionNode;
import io.ballerina.compiler.syntax.tree.MappingFieldNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.SeparatedNodeList;
import io.ballerina.compiler.syntax.tree.SpecificFieldNode;
import io.ballerina.compiler.syntax.tree.UnaryExpressionNode;
import io.ballerina.projects.plugins.SyntaxNodeAnalysisContext;
import io.ballerina.tools.diagnostics.DiagnosticFactory;
import io.ballerina.tools.diagnostics.DiagnosticInfo;

import java.util.Optional;

import static io.ballerina.stdlib.postgresql.compiler.Constants.UNNECESSARY_CHARS_REGEX;
import static io.ballerina.stdlib.postgresql.compiler.PostgreSQLDiagnosticsCode.POSTGRESQL_101;
import static io.ballerina.stdlib.postgresql.compiler.PostgreSQLDiagnosticsCode.POSTGRESQL_102;

/**
 * Utils class.
 */
public class Utils {
    public static boolean isPostgreSQLClientObject(SyntaxNodeAnalysisContext ctx, ExpressionNode node) {
        Optional<TypeSymbol> objectType = ctx.semanticModel().typeOf(node);
        if (objectType.isEmpty()) {
            return false;
        }
        if (objectType.get().typeKind() == TypeDescKind.UNION) {
            return ((UnionTypeSymbol) objectType.get()).memberTypeDescriptors().stream()
                    .filter(typeDescriptor -> typeDescriptor instanceof TypeReferenceTypeSymbol)
                    .map(typeReferenceTypeSymbol -> (TypeReferenceTypeSymbol) typeReferenceTypeSymbol)
                    .anyMatch(Utils::isPostgreSQLClientObject);
        }
        if (objectType.get() instanceof TypeReferenceTypeSymbol) {
            return isPostgreSQLClientObject(((TypeReferenceTypeSymbol) objectType.get()));
        }
        return false;
    }

    public static boolean isPostgreSQLClientObject(TypeReferenceTypeSymbol typeReference) {
        Optional<ModuleSymbol> optionalModuleSymbol = typeReference.getModule();
        if (optionalModuleSymbol.isEmpty()) {
            return false;
        }
        ModuleSymbol module = optionalModuleSymbol.get();
        if (!(module.id().orgName().equals(Constants.BALLERINAX) &&
                module.id().moduleName().equals(Constants.POSTGRESQL))) {
            return false;
        }
        String objectName = typeReference.definition().getName().get();
        return objectName.equals(Constants.Client.CLIENT);
    }

    public static void validateOptions(SyntaxNodeAnalysisContext ctx, MappingConstructorExpressionNode options) {
        SeparatedNodeList<MappingFieldNode> fields = options.fields();
        for (MappingFieldNode field : fields) {
            String name = ((SpecificFieldNode) field).fieldName().toString()
                    .trim().replaceAll(UNNECESSARY_CHARS_REGEX, "");
            ExpressionNode valueNode = ((SpecificFieldNode) field).valueExpr().get();
            switch (name) {
                case Constants.Options.CONNECT_TIMEOUT:
                case Constants.Options.LOGIN_TIMEOUT:
                case Constants.Options.SOCKET_TIMEOUT:
                case Constants.Options.CANCEL_SIGNAL_TIMEOUT:
                    float timeoutVal = Float.parseFloat(getTerminalNodeValue(valueNode));
                    if (timeoutVal < 0) {
                        DiagnosticInfo diagnosticInfo = new DiagnosticInfo(POSTGRESQL_101.getCode(),
                                POSTGRESQL_101.getMessage(), POSTGRESQL_101.getSeverity());
                        ctx.reportDiagnostic(
                                DiagnosticFactory.createDiagnostic(diagnosticInfo, valueNode.location()));
                    }
                    break;
                case Constants.Options.ROW_FETCH_SIZE:
                case Constants.Options.CACHED_METADATA_FIELD_COUNT:
                case Constants.Options.CACHED_METADATA_FIELD_SIZE:
                case Constants.Options.PREPARED_STATEMENT_THRESHOLD:
                case Constants.Options.PREPARED_STATEMENT_CACHE_QUERIES:
                case Constants.Options.PREPARED_STATEMENT_CACHE_SIZE_MIB:
                    int sizeVal = Integer.parseInt(getTerminalNodeValue(valueNode));
                    if (sizeVal <= 0) {
                        DiagnosticInfo diagnosticInfo = new DiagnosticInfo(POSTGRESQL_102.getCode(),
                                POSTGRESQL_102.getMessage(), POSTGRESQL_102.getSeverity());
                        ctx.reportDiagnostic(
                                DiagnosticFactory.createDiagnostic(diagnosticInfo, valueNode.location()));
                    }
                    break;
                default:
                    // Can ignore all the other fields
                    continue;
            }
        }
    }

    public static String getTerminalNodeValue(Node valueNode) {
        String value = "";
        if (valueNode instanceof BasicLiteralNode) {
            value = ((BasicLiteralNode) valueNode).literalToken().text();
        } else if (valueNode instanceof UnaryExpressionNode) {
            UnaryExpressionNode unaryExpressionNode = (UnaryExpressionNode) valueNode;
            value = unaryExpressionNode.unaryOperator() +
                    ((BasicLiteralNode) unaryExpressionNode.expression()).literalToken().text();
        }
        return value.replaceAll(UNNECESSARY_CHARS_REGEX, "");
    }
}
