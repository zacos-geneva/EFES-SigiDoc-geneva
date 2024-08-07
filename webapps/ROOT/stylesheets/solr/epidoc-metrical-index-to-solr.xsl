<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of symbols in those
       documents. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:lg[@met][ancestor::tei:div/@subtype='editorial']" group-by="concat(string-join(.//tei:lg, ''),'-',.)">
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:for-each select="current-group()">
              <xsl:variable name="tokens">
                    <xsl:for-each select="./descendant-or-self::text()">
                      <xsl:choose>
                        <xsl:when test="./following-sibling::tei:lb[@break='no']"><xsl:value-of select="replace(replace(., '\s+$',''), '\n', '')"/></xsl:when>
                        <xsl:when test="normalize-space(.) = ''"><xsl:value-of select="."/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:variable>
                <xsl:variable name="text" select="string-join($tokens, ' ')" />
                  <xsl:variable name="normalized-text" select="normalize-space($text)" />
                  <xsl:variable name="uppercase-text" select="translate($normalized-text, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
                 <xsl:value-of select="concat(upper-case(substring($normalized-text, 1, 1)), substring($normalized-text, 2))" />           
            </xsl:for-each>
          </field>
          <field name="index_meter">
            <xsl:for-each select="current-group()">
              <xsl:value-of select="@met" />
            </xsl:for-each>
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:lg">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
