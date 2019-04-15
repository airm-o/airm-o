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
        use-character-maps="rdf"
        exclude-result-prefixes="owl xsd rdf rdfs uml xmi airm owl thecustomprofile"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:character-map name="rdf">
        <xsl:output-character character="&amp;" string="&amp;"/>
    </xsl:character-map>
    <xsl:template match="/">
        
        
        <!--Getting owl classes and subClassOf´s-->
        <xsl:apply-templates select="xmi:XMI/xmi:Extension/elements/element"/>
        
        <!--Getting OWL Classes from Boolean UML Attributes-->
        <xsl:apply-templates
            select="/xmi:XMI/xmi:Extension/elements/element/attributes/attribute/properties"/>
        
        <!--Use if the results from this xslt is to stand on its own-->
        <xsl:text disable-output-escaping="yes">   
            &lt;/rdf:RDF&gt;
        </xsl:text>
        <!--END - Use if the results from this xslt is to stand on its own-->
    </xsl:template>
    
    <!--Transforming from UML Class to OWL Class (via XMI)-->

    <xsl:template match="xmi:XMI/xmi:Extension/elements/element">
        <!--Need to omit elements that are just "accessories" from the resulting owl-->
        <xsl:if test="compare(@xmi:type, 'uml:Boundary') != 0 
            and compare(@xmi:type,'uml:Note') != 0 
            and compare(@xmi:type,'uml:LinguisticNote') != 0
            and compare(@name, 'ConsolidatedLogicalDataModel') != 0 
            and compare(@name, 'LinguisticNote') !=0 
            and compare(@name, 'Note') !=0">
  
            <!-- Get the subject field this element belongs to-->
            <xsl:variable name="subjectField">
                <xsl:for-each select="tags/tag">
                    <xsl:if test="compare(@name, 'URN') = 0">
                        <xsl:value-of select="substring-before(substring-after(@value, 'urn:x-ses:sesarju:airm:v410:ConsolidatedLogicalDataModel:SubjectFields:'), ':Codelists:')"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            
            
            
            <!--Check if the element is a package (xmi:Type = Package) or a class (uml:Class). If they are packages then they 
            should be underscored, if they are classes they should not-->          
            <xsl:variable name="class_name">
                <xsl:choose>
                    <!--If the element name is 'Codelists' we suffix this with the name of the subject field this code list belongs to so that
                    all codelists are grouped under its appropriate subject field in the resulting owl-->
                    <xsl:when test="compare(@name, 'Codelists') = 0">
                        <xsl:value-of select="concat('_',@name,'_',extendedProperties/@package_name,'_')"/> 
                    </xsl:when>
                    <xsl:when test="compare(@xmi:type, 'uml:Package') = 0">
                        <xsl:value-of select="concat('_',@name,'_')"/> 
                    </xsl:when>
                    <xsl:when test="compare(@xmi:type, 'uml:Class') = 0">
                        <xsl:value-of select="@name"/> 
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>

            <!--All extended properties are references to packages, so they should all be "underscored"-->
            <xsl:variable name="super_class">
                <xsl:choose>
                    <xsl:when test="compare(extendedProperties/@package_name, 'Codelists') = 0">
                        <xsl:value-of select="concat('_','Codelists','_',$subjectField,'_')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('_',extendedProperties/@package_name,'_')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <owl:Class rdf:about="&amp;airm;{$class_name}">
                
                <!--Don´t want to include the ConsolidatedLogicalModel in the output-->
                <!--Nor to have the specific entities and ObjectWithSchedule represented twice (both as subclasses to _Abstract_ and to Entity / Object -->
                <xsl:if test="compare(extendedProperties/@package_name, 'ConsolidatedLogicalDataModel') != 0
                    and (compare($class_name, 'GeoTemporalEnabledEntity') != 0) 
                    and (compare($class_name, 'TemporalEnabledEntity') != 0)
                    and (compare($class_name, 'GeoEnabledEntity') != 0) 
                    and (compare($class_name, 'ObjectWithSchedule') != 0) 
                    and (compare($class_name, 'EntityCollection') != 0)">
                <rdfs:subClassOf rdf:resource="&amp;airm;{$super_class}"/>
                </xsl:if>
                
                <!--getting additional subClassOf relations from the generalization connectors-->
                <!--this retrieves the Entity and Object hierarchies-->
                <xsl:for-each select="/xmi:XMI/xmi:Extension/connectors/connector">
                    <!--if properties type is 'Generalization' and the class name and the name of the source class in 
                the relationship matches, then extract the target class name as object in the subClassOf statement-->
 
                    <xsl:if test="compare(properties/@ea_type, 'Generalization') = 0 
                        and compare($class_name, source/model/@name) = 0 
                        and compare(source/model/@name,'LinguisticNote') != 0 
                        and compare(target/model/@name,'ConsolidatedLogicalDataModel') != 0 
                        and compare(target/model/@name,'AngularVelocity') != 0
                        and compare(target/model/@name,'DateTime') != 0
                        and compare(target/model/@name,'GM_Curve') != 0
                        and compare(target/model/@name,'GM_Point') != 0
                        and compare(target/model/@name,'GM_Surface') != 0
                        and compare(target/model/@name,'TM_Duration') != 0
                        and compare(target/model/@name,'Measure') != 0">
                        
                        <xsl:choose>
                            <!--'CharacterString' should be replaced by 'Code', so if the target of the generalization relationship for this particular 
                                class is 'CharacterString', we change this so that the target class instead becomes 'Code'-->
                            <xsl:when test="compare(target/model/@name,'CharacterString') = 0">
                                <!--Commenting out the below subClassOf statement to avoid having a separate Code class with duplicate code list representations in the 
                                resulting owl-->
                            <!--<rdfs:subClassOf rdf:resource="&amp;airm;{'Test'}"/>-->
                            </xsl:when>
                            <xsl:otherwise>
                                <rdfs:subClassOf rdf:resource="&amp;airm;{target/model/@name}"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
                
            </owl:Class>
        </xsl:if>
    </xsl:template>

    <!--Transforming from Boolean UML Attributes to OWL Class (via XMI)-->
    <xsl:template match="/xmi:XMI/xmi:Extension/elements/element/attributes/attribute/properties">
        <!--If properties type is 'Boolean', select the element name (e.g. Runway) and the attribute name (e.g. isAbandoned)
            and concatenate the two into a new class name. Further, extract the documentation associated with this attribute
            and put that as rdfs:comment.-->
        <xsl:if test="@type = 'Boolean'">
            <!--elements/element/@name-->
            <xsl:variable name="element_name" select="../../../@name"/>
            <!--attribute/@name-->
            <xsl:variable name="attribute_name" select="../@name"/>
            <xsl:variable name="comment" select="../documentation/@value"/>
            <owl:Class rdf:about="&amp;airm;{concat($element_name, '-', $attribute_name)}">
                <rdfs:subClassOf rdf:resource="&amp;airm;{$element_name}"/>
                <rdfs:comment>
                    <xsl:value-of select="$comment"/>
                </rdfs:comment>
            </owl:Class>
        </xsl:if>   
    </xsl:template>
    
    <!--Not applied for now-->
    <xsl:template name="createDisjoints_classes">
        
        
        <owl:Class rdf:about="&airm;RunwayContamination">
            <rdfs:subClassOf rdf:resource="&airm;_SurfaceContamination_"/>
            <owl:disjointWith rdf:resource="&airm;RunwaySectionContamination"/>
        </owl:Class>
        
        
    </xsl:template>
    
    
</xsl:stylesheet>
