<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
  version="2.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1">
  
  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of symbols in those
       documents. -->
  
  <xsl:import href="epidoc-index-utils.xsl" />
  
  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />
  
  <xsl:variable name="al" select="'../../content/xml/authority/symbols.xml'"/>
  <xsl:variable name="symbol" select="replace(@ref,'#', '')"/>
  
  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:g[ancestor::tei:div/@type='edition']" group-by="if (@ref and not(starts-with(@ref, 'http'))) then replace(@ref, '#', '') else if (@type and not(starts-with(@type, 'http'))) then replace(@ref, '#', '') else if (//text()) then normalize-space(.) else name()">
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <field name="index_item_name">
            <xsl:choose>
              <xsl:when test="doc-available($al) = fn:true() and document($al)//tei:item[@xml:id=$symbol]">
                <xsl:variable name="symbol-id" select="document($al)//tei:item[@xml:id=$symbol]"/>
                <xsl:choose>
                  <xsl:when test="$symbol-id//tei:g">
                    <xsl:value-of select="$symbol-id//tei:g"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$symbol-id//tei:term[1]"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </field>
          <xsl:call-template name="field_file_path" />
          <xsl:variable name="id">
            <xsl:choose>
              <xsl:when test="@ref and not(starts-with(@ref, 'http'))">
                <xsl:value-of select="replace(@ref, '#', '')"/>
              </xsl:when>
              <xsl:when test="@type and not(starts-with(@type, 'http'))">
                <xsl:value-of select="replace(@type, '#', '')"/>
              </xsl:when>
              <xsl:when test="//text()">
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'Other symbol'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <field name="index_meaning">
            <xsl:choose>
              <xsl:when test="doc-available($al) = fn:true() and document($al)//tei:item[@xml:id=$id]/tei:term[@xml:lang='en']">
                <xsl:value-of select="document($al)//tei:item[@xml:id=$id]/tei:term[@xml:lang='en'][1]"/>
              </xsl:when>
              <xsl:when test="doc-available($al) = fn:true() and document($al)//tei:item[@xml:id=$id]/tei:term">
                <xsl:value-of select="document($al)//tei:item[@xml:id=$id]/tei:term[1]"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="replace($id, '-', ' ')"/>
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>
  
  <xsl:template match="tei:g">
    <xsl:call-template name="field_index_instance_location" >
      <xsl:with-param name="index-lines" select="'yes'"/>
    </xsl:call-template>
  </xsl:template>
  
</xsl:stylesheet>
