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
        
        <xsl:apply-templates select="/xmi:XMI/xmi:Extension/elements/element/properties"/>

    </xsl:template>
    
    <xsl:template match="/xmi:XMI/xmi:Extension/elements/element/properties">

        <xsl:if test="compare(@stereotype, 'CodeList') = 0">
            
            <xsl:for-each select="../attributes/attribute">

                <xsl:variable name="codelist_name" select="../../@name"/>
                <xsl:variable name="codelist_value" select="@name"/>
                <xsl:variable name="comment" select="documentation/@value"/>

            <owl:NamedIndividual rdf:about="&amp;airm;{concat($codelist_name, '-', $codelist_value)}">
                <rdf:type rdf:resource="&amp;airm;{$codelist_name}"/>
                <rdfs:label><xsl:value-of select="$codelist_value"/></rdfs:label>
                <rdfs:comment><xsl:value-of select="$comment"/></rdfs:comment>
            </owl:NamedIndividual>
            
            </xsl:for-each>
        </xsl:if>
        
    </xsl:template>
</xsl:stylesheet>