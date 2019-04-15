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
    
    <!--Imports the XSLT scripts that do the actual transformation from XMI to OWL-->
    <xsl:import href="airm_xslt_xmi2owl_Classes.xsl"/>
    <xsl:import href="airm_xslt_xmi2owl_ObjectProperties.xsl"/>
    <xsl:import href="airm_xslt_xmi2owl_DatatypeProperties.xsl"/>
    <xsl:import href="airm_xslt_xmi2owl_Individuals.xsl"/>
    
    
    <!--Indents the results to get the proper xml formatting-->
    <xsl:output media-type="text/xml" version="1.0" encoding="UTF-8" indent="yes"
        use-character-maps="rdf" exclude-result-prefixes="owl xsd rdf rdfs uml xmi airm owl thecustomprofile"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:character-map name="rdf">
        <xsl:output-character character="&amp;" string="&amp;"/>
    </xsl:character-map>
    
    <xsl:template match="/">
        <xsl:text disable-output-escaping="yes">          
            &lt;!DOCTYPE rdf:RDF [
            &lt;!ENTITY owl "http://www.w3.org/2002/07/owl#" &gt;
            &lt;!ENTITY xsd "http://www.w3.org/2001/XMLSchema#" &gt;
            &lt;!ENTITY airm "http://www.best-project.org/owl/AIRM#" &gt;
            &lt;!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#" &gt;
            &lt;!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#" &gt;          
            ]&gt;
            
            &lt;rdf:RDF xmlns="http://www.best-project.org/owl/AIRM#"
            xml:base="http://www.best-project.org/owl/AIRM"
            xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
            xmlns:airm="http://www.best-project.org/owl/AIRM#"
            xmlns:owl="http://www.w3.org/2002/07/owl#"
            xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            &lt;owl:Ontology rdf:about="http://www.best-project.org/owl/AIRM"/&gt;             
        </xsl:text>
        
        <!--Getting owl classes and subClassOf´s-->
        <xsl:apply-templates select="xmi:XMI/xmi:Extension/elements/element"/>
        
        <!--Getting OWL Classes from Boolean UML Attributes-->
        <xsl:apply-templates select="xmi:XMI/xmi:Extension/elements/element/attributes/attribute/properties"/>
        
       <!-- Setting the object property structure-->
        <xsl:call-template name="OP_OverallStructure"/>
        
        <!--Transforming UML aggregation associations to object properties-->
        <xsl:call-template name="OP_UMLAggregation2OP"/>
        
        <!--Getting owl object properties from UML associations-->
        <xsl:apply-templates select="xmi:XMI/xmi:Extension/connectors/connector"/>
        
        <!--Getting OWL ObjectProperty from UML Attributes (with complex datatypes (code lists)-->
        <xsl:apply-templates select="xmi:XMI/xmi:Extension/elements/element/attributes"/>
        
        <!--Setting the overall structure of the data properties-->
        <xsl:call-template name="DP_OverallStructure"/>
        
        <!--Getting OWL Data Properties from UML Attributes-->
        <xsl:call-template name="DP_UMLAttributes2DP"/>
        
        
        <!--Getting OWL NamedIndividuals from Codelist values-->
        <xsl:apply-templates select="xmi:XMI/xmi:Extension/elements/element/properties"/>
        
        <xsl:text disable-output-escaping="yes">   
            &lt;/rdf:RDF&gt;
        </xsl:text>
    
    </xsl:template>
</xsl:stylesheet>
