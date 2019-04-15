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
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xmi="http://schema.omg.org/spec/XMI/2.1"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:airm="http://www.best-project.org/owl/AIRM#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
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
        
        <!--Setting the overall structure of the data properties-->
        <xsl:call-template name="DP_OverallStructure"/>
        
        <!--Getting OWL Data Properties from UML Attributes-->
        <xsl:call-template name="DP_UMLAttributes2DP"/>
        
        
    </xsl:template>
    
    <xsl:template name="DP_OverallStructure">
        
        <xsl:for-each select="/xmi:XMI/xmi:Extension/elements/element">
            <xsl:choose>
                <xsl:when test="
                    compare(@xmi:type, 'uml:Package') = 0
                    and compare(@name, 'v4.1.0') != 0
                    and compare(@name, 'ConsolidatedLogicalDataModel') != 0
                    and compare(@name, 'EntityCollection') != 0
                    and compare(extendedProperties/@package_name, 'Codelists') != 0
                    and compare(extendedProperties/@package_name, 'ConsolidatedLogicalDataModel') != 0
                    and compare(extendedProperties/@package_name, 'LinguisticNote') != 0
                    and not(starts-with(@name, 'Code'))
                    ">
                    <owl:DatatypeProperty rdf:about="&amp;airm;_{@name}_DP_">
                        <rdfs:subPropertyOf
                            rdf:resource="&amp;airm;_{extendedProperties/@package_name}_DP_"/>
                    </owl:DatatypeProperty>
                </xsl:when>
                <xsl:when test="
                    compare(@xmi:type, 'uml:Class') = 0
                    and compare(@name, 'Note') != 0
                    and compare(@name, 'LinguisticNote') != 0
                    and compare(@name, 'EntityCollection') != 0
                    ">
                    <!--<xsl:for-each select="attributes/attribute">
                            <xsl:if test="
                                compare(properties/@type, 'CharacterString') = 0
                                or compare(properties/@type, 'Integer') = 0
                                or compare(properties/@type, 'Date') = 0
                                or compare(properties/@type, 'TM_Duration') = 0
                                or compare(properties/@type, 'Decimal') = 0
                                or compare(properties/@type, 'Angle') = 0 
                                ">-->
 
                    <owl:DatatypeProperty rdf:about="&amp;airm;{@name}_DP_">
                        <rdfs:subPropertyOf
                            rdf:resource="&amp;airm;_{extendedProperties/@package_name}_DP_"/>
                    </owl:DatatypeProperty>
    <!--                        </xsl:if>
                    </xsl:for-each>-->
                    
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="DP_UMLAttributes2DP">
        
        <xsl:for-each select="/xmi:XMI/xmi:Extension/elements/element/attributes/attribute/properties">
            
            <xsl:variable name="element_name" select="../../../@name"/>
            <xsl:variable name="attribute_name" select="../@name"/>
            <xsl:variable name="comment" select="../documentation/@value"/>
            
            <xsl:if test="@type != 'Boolean' and not(ends-with(@type, 'Type') and not(starts-with(@type, 'Code'))) 
                and compare($element_name, 'LinguisticNote') !=0
                and compare($element_name, 'Note') !=0
                ">
                
                <owl:DatatypeProperty rdf:about="&amp;airm;{concat($element_name, '-', $attribute_name)}">
                    <rdf:type rdf:resource="&amp;owl;FunctionalProperty"></rdf:type>
                    <rdfs:label><xsl:value-of select="$attribute_name"/></rdfs:label>
                    <rdfs:comment><xsl:value-of select="$comment"/></rdfs:comment>
                    <rdfs:subPropertyOf rdf:resource="&amp;airm;{$element_name}_DP_"/>
                    <rdfs:domain rdf:resource="&amp;airm;{$element_name}"/>
                    
                    <xsl:choose>
                        <xsl:when test="compare(@type, 'CharacterString') = 0"><rdfs:range rdf:resource="&amp;xsd;string"/></xsl:when>
                        <xsl:when test="compare(@type, 'Date') = 0"><rdfs:range rdf:resource="&amp;xsd;date"/></xsl:when>
                        <xsl:when test="compare(@type, 'Integer') = 0"><rdfs:range rdf:resource="&amp;xsd;integer"/></xsl:when>
                        <xsl:when test="compare(@type, 'Real') = 0"><rdfs:range rdf:resource="&amp;xsd;integer"/></xsl:when>
                        <xsl:when test="compare(@type, 'TM_Duration') = 0"><rdfs:range rdf:resource="&amp;xsd;duration"/></xsl:when>
                        <xsl:when test="compare(@type, 'Decimal') = 0"><rdfs:range rdf:resource="&amp;xsd;decimal"/></xsl:when>
                        <xsl:when test="compare(@type, 'Angle') = 0"><rdfs:range rdf:resource="&amp;xsd;decimal"/></xsl:when>
                    </xsl:choose>
                    
                </owl:DatatypeProperty>
                
            </xsl:if>
            
        </xsl:for-each>
        
    </xsl:template>
    
    
</xsl:stylesheet>