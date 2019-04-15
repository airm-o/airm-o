<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE rdf:RDF [
    <!ENTITY xsd "http://www.w3.org/2001/XMLSchema#" >
    <!ENTITY owl "http://www.w3.org/2002/07/owl#" >
    <!ENTITY airm "http://www.best-project.org/owl/AIRM#" >
    <!ENTITY xml "http://www.w3.org/XML/1998/namespace" >
    <!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#" >
    <!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#" >
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xmi="http://schema.omg.org/spec/XMI/2.1"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:airm="http://www.best-project.org/owl/AIRM#" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:uml="http://schema.omg.org/spec/UML/2.1"
    xmlns:thecustomprofile="http://www.sparxsystems.com/profiles/thecustomprofile/1.0"
    exclude-result-prefixes="owl xsd rdf rdfs uml xmi airm owl thecustomprofile" version="2.0">
    
    <!--Indents the results to get the proper xml formatting-->
    <xsl:output media-type="text/xml" version="1.0" encoding="UTF-8" indent="yes"
        use-character-maps="rdf"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:character-map name="rdf">
        <xsl:output-character character="&amp;" string="&amp;"/>
    </xsl:character-map>
    
    <xsl:template match="/">
        <!--Setting the overall structure of the object properties-->
        <xsl:call-template name="OP_OverallStructure"/>
        
        <!--Properly structuring the object properties for UML aggregation associations-->
        <xsl:call-template name="OP_UMLAggregation2OP"/>
        
      <!-- Getting owl object properties from UML associations-->
      <xsl:apply-templates select="xmi:XMI/xmi:Extension/connectors/connector"/>

       <!--Getting OWL ObjectProperty from UML Attributes (with complex datatypes (code lists)-->
     <xsl:apply-templates select="xmi:XMI/xmi:Extension/elements/element/attributes"/>

        
    </xsl:template>
    <!--Transforming from UML Association to OWL Object Property (via XMI)-->
    <xsl:template match="xmi:XMI/xmi:Extension/connectors/connector">
        <!--Check if this is a package or a class; if package append underscores-->
        <xsl:variable name="class_name">
            <xsl:if
                test="
                    compare(source/model/@name, 'ConsolidatedLogicalDataModel') != 0
                    and compare(source/model/@name, 'GeometryTypes') != 0
                    and compare(source/model/@name, 'HexType') != 0
                    and compare(source/model/@name, 'IdentifierType') != 0
                    and compare(source/model/@name, 'MeasureTypes') != 0
                    and compare(source/model/@name, 'UnitsOfMeasure') != 0
                    and compare(source/model/@name, 'TemporalTypes') != 0
                    and compare(source/model/@name, 'RangeTypes') != 0
                    and compare(source/model/@name, 'SubjectFields') != 0
                    and compare(source/model/@name, 'EntityCollection') != 0
                    and compare(source/model/@name, 'LinguisticNote') != 0
                    and compare(source/model/@name, 'Note') != 0
                    and compare(target/model/@name, '') != 0
                    ">
                <xsl:choose>
                    <xsl:when test="compare(source/model/@type, 'Package') = 0">
                        <xsl:value-of select="concat('_', source/model/@name, '_')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="source/model/@name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:variable>
        <!--Check if this is a package or a class; if package append underscores-->
        <xsl:variable name="range">
            <xsl:if
                test="
                    compare(target/model/@name, 'ConstraintsModel') != 0
                    and compare(target/model/@name, 'ConsolidatedLogicalDataModel') != 0
                    and compare(target/model/@name, 'AngularVelocity') != 0
                    and compare(target/model/@name, 'DateTime') != 0
                    and compare(target/model/@name, 'GM_Curve') != 0
                    and compare(target/model/@name, 'GM_Point') != 0
                    and compare(target/model/@name, 'GM_Surface') != 0
                    and compare(target/model/@name, 'TM_Duration') != 0
                    and compare(target/model/@name, 'Measure') != 0
                    and compare(target/model/@name, 'FoundationLibrary') != 0
                    and compare(target/model/@name, 'InformationModel') != 0
                    and compare(target/model/@name, 'ISO') != 0
                    and compare(target/model/@name, 'Infrastructure') != 0
                    and compare(target/model/@name, 'Note') != 0
                    and compare(target/model/@name, 'Operations') != 0
                    and compare(target/model/@name, 'Stakeholder') != 0
                    and compare(target/model/@name, 'MD_Metadata') != 0
                    and compare(properties/@ea_type, 'Generalization') != 0
                    ">
                <xsl:choose>
                    <xsl:when test="compare(target/model/@type, 'Package') = 0">
                        <xsl:value-of select="concat('_', target/model/@name, '_')"/>
                    </xsl:when>
                    <xsl:when test="compare(target/model/@name, 'CharacterString') = 0">
                        <xsl:value-of select="'Code'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="target/model/@name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:variable>
        <!--If the attribute target/role/@name is non-existent, the range class name becomes the role name-->
        <!--<xsl:variable name="role_name" select="target/role/@name"/>-->
        <xsl:variable name="role_name">
            <xsl:choose>
                <!--If a role name exists-->
                <xsl:when test="count(target/role/@name) > 0">
                    <xsl:value-of select="target/role/@name"/>
                </xsl:when>
                <xsl:when test="compare(target/model/@name, 'CharacterString') = 0">
                    <xsl:value-of select="'code'"/>
                </xsl:when>
                <!--If no role name exists we use the range class name as role name as long as the range class does not refer to a package-->
                <xsl:otherwise>
                    <xsl:value-of select="lower-case(target/model/@name)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if
            test="$class_name != '' and $role_name != '' and $range != ''
                and compare($class_name, 'Operations') != 0
                and compare($class_name, 'Stakeholder') != 0
                and compare($class_name, 'Traffic') != 0">
            <owl:ObjectProperty rdf:about="&amp;airm;{concat($class_name, '-', $role_name)}">
                <rdfs:domain rdf:resource="&amp;airm;{$class_name}"/>
                <rdfs:range rdf:resource="&amp;airm;{$range}"/>
                <rdfs:subPropertyOf rdf:resource="&amp;airm;{$class_name}_OP_"/>
            </owl:ObjectProperty>
        </xsl:if>
    </xsl:template>
    
    <!--Transforming from UML Attributes (with complex datatypes (code lists) to OWL Object Property (via XMI)-->
    <xsl:template match="xmi:XMI/xmi:Extension/elements/element/attributes">
        <xsl:for-each select="attribute">
            <xsl:variable name="element_name" select="../../@name"/>
            <xsl:variable name="attribute_name" select="@name"/>
            <xsl:variable name="range" select="properties/@type"/>
            <xsl:if test="ends-with($range, 'Type') and compare($element_name, 'Note') != 0">
                <owl:ObjectProperty
                    rdf:about="&amp;airm;{concat($element_name, '-', $attribute_name)}">
                    <rdf:type rdf:resource="&amp;owl;FunctionalProperty"/>
                    <rdfs:domain rdf:resource="&amp;airm;{$element_name}"/>
                    <rdfs:range rdf:resource="&amp;airm;{$range}"/>
                    <rdfs:subPropertyOf rdf:resource="&amp;airm;{$element_name}_OP_"/>
                </owl:ObjectProperty>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <!--Transforming from UML Aggregation to OWL Object Property (via XMI)-->
    <xsl:template match="xmi:XMI/xmi:Extension/connectors">
        <xsl:variable name="model_name" select="connector/source/model/@name"/>
        <xsl:variable name="role_name" select="connector/target/role/@name"/>
        <xsl:variable name="range" select="connector/target/model/@name"/>
        <xsl:if test="compare(source/type/@aggregation, 'shared') = 0">
            <owl:ObjectProperty rdf:about="&amp;airm;{concat($model_name, '-', $role_name)}">
                <rdf:type rdf:resource="&amp;owl;FunctionalProperty"/>
                <rdf:type rdf:resource="&amp;owl;InverseFunctionalProperty"/>
                <rdfs:subPropertyOf rdf:resource="&amp;airm;{$model_name}_OP_"/>
                <rdfs:domain rdf:resource="&amp;airm;{$model_name}"/>
                <rdfs:range rdf:resource="&amp;airm;{$range}"/>
            </owl:ObjectProperty>
        </xsl:if>
    </xsl:template>
    <xsl:template name="OP_UMLAggregation2OP">
        <xsl:for-each select="/xmi:XMI/xmi:Extension/connectors/connector">
            <xsl:variable name="model_name" select="source/model/@name"/>
            <xsl:variable name="role_name" select="target/role/@name"/>
            <xsl:variable name="range" select="target/model/@name"/>
            <xsl:if
                test="
                    compare(source/type/@aggregation, 'shared') = 0
                    and compare($model_name, 'Note') != 0
                    and compare($model_name, 'EntityCollection') != 0
                    and compare($range, 'Note') != 0
                    ">
                <owl:ObjectProperty rdf:about="&amp;airm;{concat($model_name, '-', $role_name)}">
                    <rdf:type rdf:resource="&amp;owl;FunctionalProperty"/>
                    <rdf:type rdf:resource="&amp;owl;InverseFunctionalProperty"/>
                    <rdfs:subPropertyOf rdf:resource="&amp;airm;{$model_name}_OP_"/>
                    <rdfs:domain rdf:resource="&amp;airm;{$model_name}"/>
                    <rdfs:range rdf:resource="&amp;airm;{$range}"/>
                </owl:ObjectProperty>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="OP_OverallStructure">
        <xsl:for-each select="/xmi:XMI/xmi:Extension/elements/element">
            <xsl:choose>
                <xsl:when
                    test="
                        compare(@xmi:type, 'uml:Package') = 0
                        and compare(@name, 'v4.1.0') != 0
                        and compare(@name, 'ConsolidatedLogicalDataModel') != 0
                        and compare(@name, 'EntityCollection') != 0
                        and compare(extendedProperties/@package_name, 'Codelists') != 0
                        and compare(extendedProperties/@package_name, 'ConsolidatedLogicalDataModel') != 0">
                    <owl:ObjectProperty rdf:about="&amp;airm;_{@name}_OP_">
                        <rdfs:subPropertyOf
                            rdf:resource="&amp;airm;_{extendedProperties/@package_name}_OP_"/>
                    </owl:ObjectProperty>
                </xsl:when>
                <xsl:when
                    test="
                        compare(@xmi:type, 'uml:Class') = 0
                        and compare(@name, 'Note') != 0
                        and compare(@name, 'LinguisticNote') != 0
                        and compare(@name, 'EntityCollection') != 0">
                    <owl:ObjectProperty rdf:about="&amp;airm;{@name}_OP_">
                        <rdfs:subPropertyOf
                            rdf:resource="&amp;airm;_{extendedProperties/@package_name}_OP_"/>
                    </owl:ObjectProperty>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
