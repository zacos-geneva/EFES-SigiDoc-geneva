<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a TEI document into a Solr index
       document. -->

  <!-- Path to the TEI file being indexed. -->
  <xsl:param name="file-path" />

  <xsl:variable name="document-metadata">
    <xsl:apply-templates mode="document-metadata" select="/*/tei:teiHeader" />
  </xsl:variable>

  <xsl:variable name="free-text">
    <xsl:apply-templates mode="free-text" select="/*/tei:text" />
  </xsl:variable>

  <xsl:template match="/">
    <!-- Entity mentions are restricted to the text of the document;
         entities keyed in the TEI header are document metadata. -->
    <xsl:apply-templates mode="entity-mention" select="/*/tei:text//tei:*[@key]" />

    <!-- Text content -->
    <xsl:if test="normalize-space($free-text)">
      <doc>
        <xsl:sequence select="$document-metadata" />
        <xsl:call-template name="field_document_type" />
        <xsl:call-template name="field_file_path" />
        <xsl:call-template name="field_document_id" />
        <xsl:call-template name="field_text" />
        <xsl:call-template name="field_lemmatised_text" />
        <!-- Facets. -->
        <xsl:call-template name="field_found_provenance" />
        <xsl:call-template name="field_mentioned_people" />
        <xsl:call-template name="field_mentioned_places" />
        <xsl:call-template name="field_origin_place" />
        <xsl:call-template name="field_support_object_type" />
        <xsl:call-template name="field_support_material" />
        <xsl:call-template name="extra_fields" />
      </doc>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:fileDesc/tei:titleStmt/tei:title" mode="document-metadata">
    <field name="document_title">
      <xsl:value-of select="normalize-space(.)" />
    </field>
  </xsl:template>

  <xsl:template match="tei:fileDesc/tei:titleStmt/tei:author" mode="document-metadata">
    <field name="author">
      <xsl:value-of select="normalize-space(.)" />
    </field>
  </xsl:template>

  <xsl:template match="tei:fileDesc/tei:titleStmt/tei:editor" mode="document-metadata">
    <field name="editor">
      <xsl:value-of select="normalize-space(.)" />
    </field>
  </xsl:template>

  <xsl:template match="tei:sourceDesc//tei:publicationStmt/tei:date[1]"
                mode="document-metadata">
    <xsl:if test="@when">
      <field name="publication_date">
        <xsl:value-of select="@when" />
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template match="text()" mode="document-metadata" />

  <xsl:template match="node()" mode="free-text">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="@lemma" mode="lemma">
    <xsl:value-of select="." />
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="node()|@*" mode="lemma">
    <xsl:apply-templates mode="lemma" select="@*|node()" />
  </xsl:template>

  <xsl:template match="tei:*[@key]" mode="entity-mention">
    <doc>
      <xsl:sequence select="$document-metadata" />

      <field name="file_path">
        <xsl:value-of select="$file-path" />
      </field>
      <field name="document_id">
        <xsl:value-of select="/tei:*/@xml:id" />
      </field>
      <field name="section_id">
        <xsl:value-of
          select="ancestor::tei:*[self::tei:div or self::tei:body or self::tei:front or self::tei:back or self::tei:group or self::tei:text][@xml:id][1]/@xml:id"
         />
      </field>
      <field name="entity_key">
        <xsl:value-of select="@key" />
      </field>
      <field name="entity_name">
        <xsl:value-of select="normalize-space(.)" />
      </field>
    </doc>
  </xsl:template>

  <xsl:template match="tei:material[@ref]" mode="facet_support_material">
    <field name="support_material">
      <xsl:value-of select="@ref" />
    </field>
  </xsl:template>

  <xsl:template match="tei:origPlace[@ref]" mode="facet_origin_place">
    <!-- This does nothing to prevent duplicate instances of the same
         @ref value being recorded. -->
    <field name="origin_place">
      <xsl:value-of select="@ref" />
    </field>
  </xsl:template>

  <xsl:template match="tei:objectType[@ref]" mode="facet_support_object_type">
    <field name="support_object_type">
      <xsl:value-of select="@ref" />
    </field>
  </xsl:template>

  <xsl:template match="tei:persName[@ref]" mode="facet_mentioned_people">
    <field name="mentioned_people">
      <xsl:value-of select="@ref" />
    </field>
  </xsl:template>

  <xsl:template match="text()" mode="facet_mentioned_people" />

  <xsl:template match="tei:placeName[@ref]" mode="facet_found_provenance">
    <field name="found_provenance">
      <xsl:value-of select="@ref" />
    </field>
  </xsl:template>

  <xsl:template match="tei:placeName[@ref] | tei:geogName[@ref]" mode="facet_mentioned_places">
    <field name="mentioned_places">
      <xsl:value-of select="@ref" />
    </field>
  </xsl:template>

  <xsl:template match="text()" mode="facet_mentioned_places" />

  <xsl:template name="field_document_id">
    <field name="document_id">
      <xsl:value-of select="/tei:*/@xml:id" />
    </field>
  </xsl:template>

  <xsl:template name="field_document_type">
    <field name="document_type">
      <xsl:value-of select="substring-before($file-path, '/')" />
    </field>
  </xsl:template>

  <xsl:template name="field_file_path">
    <field name="file_path">
      <xsl:value-of select="$file-path" />
    </field>
  </xsl:template>

  <xsl:template name="field_found_provenance">
    <xsl:apply-templates mode="facet_found_provenance" select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:provenance[@type='found']" />
  </xsl:template>

  <xsl:template name="field_lemmatised_text">
    <field name="lemmatised_text">
      <xsl:apply-templates mode="lemma" select="//tei:text" />
    </field>
  </xsl:template>

  <xsl:template name="field_mentioned_people">
    <xsl:apply-templates mode="facet_mentioned_people" select="//tei:text/tei:body/tei:div[@type='edition']" />
  </xsl:template>

  <xsl:template name="field_mentioned_places">
    <xsl:apply-templates mode="facet_mentioned_places" select="//tei:text/tei:body/tei:div[@type='edition']" />
  </xsl:template>

  <xsl:template name="field_origin_place">
    <xsl:apply-templates mode="facet_origin_place" select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origPlace[@ref]" />
  </xsl:template>

  <xsl:template name="field_support_material">
    <xsl:apply-templates mode="facet_support_material" select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:material[@ref]" />
  </xsl:template>

  <xsl:template name="field_support_object_type">
    <xsl:apply-templates mode="facet_support_object_type" select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:objectType[@ref]" />
  </xsl:template>

  <xsl:template name="field_text">
    <field name="text">
      <xsl:value-of select="normalize-space($free-text)" />
    </field>
  </xsl:template>

</xsl:stylesheet>
