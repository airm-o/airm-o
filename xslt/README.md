Transformation from AIRM UML to AIRM-O
===

The XSLT scripts ship as a set of files that collectively transform the ATM Information Reference Model (AIRM) from its original UML representation to OWL (AIRM-O).

Overview
---

The main XSLT file is airm_xslt_xmi2owl_Main.xsl which imports the other XSLT files in the folder. These include:
*	airm_xslt_xmi2owl_Classes.xsl 
*	airm_xslt_xmi2owl_ObjectProperties.xsl 
*	airm_xslt_xmi2owl_DatatypeProperties.xsl 
*	airm_xslt_xmi2owl_Individuals.xsl 

XSLT Parser
---

The XSLT scripts are known to work with Saxon-PE 9.6.0.5 as parser for for running the transformatiois and OxygenXML as the XMI editor. You'll find an XMI version of the current AIRM version in the airm-xmi folder. 

**Post-Processing of XMI (after export from Sparx Systems Enterprise Architect UML editor)**.
The XMI generated from Sparx Systems Enterprise Architect must be preprocessed before running the actual transformations. The following preprocessing steps must be performed prior to the transformation:

1. Fix duplicate datatype entry:
The SAXON parser throws an error since there are two data types declared for “PackagedElement.PackagedElement.OwnedAttribute.upperValue. This types are ‘uml:LiteralInteger’ and ‘uml:LiteralUnlimitedNatural’. This is resolved by removing ‘uml:LiteralInteger’.

2. Removal of not needed elements in XMI:
 
   *	Remove the uml:Model branch of the XMI, since this includes duplicates of the xmi:Extension
 
   *	Remove the <diagrams> elements since they do not contain any information relevant for the transformation
 
   *	Remove the top-level UML packages (e.g. “v4.1.0”) as we do not want that as a part of the resulting OWL. 

3. Removal of whitespace from the following names
 
   *	assignedEndPosition
 
   *	flightLevelChange
 
   *	requiredRouteOffset
 
   *	cruisingLevel
 
   *	IN_DEMOLITION
 
   *	INTERMEDIATE_POINT
 
   *	NATIONAL_REGISTERING_AUTHORITY
 
   *	PLANNER_ ATCO
 
   *	TACTICAL_ ATCO


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

