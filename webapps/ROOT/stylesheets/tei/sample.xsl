<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

     <xsl:param name="view" />
     <xsl:param name="filename" />
     
  <!-- Project-specific XSLT for transforming TEI to
       HTML. Customisations here override those in the core
       to-html.xsl (which should not be changed). -->
     <xsl:import href="to-html.xsl" />
     
    <!-- <xsl:param name="lang" select="$lang"/>
     <xsl:param name="kiln:assets-path" select="$kiln:assets-path"/>
     <xsl:param name="kiln:url-lang-suffix" select="$kiln:url-lang-suffix"/>
    
     <xsl:template match="/"/>-->
     
     <!-- GREEK -->
     <xsl:template match="tei:foreign[@xml:lang='grc']|tei:term[@xml:lang='grc']"><!--added-->
          <span lang="grc" xsl:exclude-result-prefixes="tei">
               <xsl:apply-templates/>
          </span>
     </xsl:template>
    
</xsl:stylesheet>
