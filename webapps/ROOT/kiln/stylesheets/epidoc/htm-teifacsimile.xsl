<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet exclude-result-prefixes="t"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0"
                version="2.0">

  <xsl:template match="t:facsimile">
    <!-- Being concerned only with the images, ignore everything else. -->
    <div id="facsimile-images">
      <h2>Facsimile Images</h2>

      <xsl:apply-templates select=".//t:graphic" />
    </div>
  </xsl:template>

  <xsl:template match="t:graphic">
    <xsl:param name="parm-image-loc" select="''" tunnel="yes" />
    <!-- Create a link to the full image and display a thumbnail
         image. -->
    <xsl:variable name="url-parts" select="tokenize(@url, '\.')" />
    <xsl:variable name="count-url-parts" select="count($url-parts)-1" />
    <a href="{concat($parm-image-loc, @url)}">
      <img title="{t:desc}">
        <xsl:attribute name="src">
          <xsl:value-of select="$parm-image-loc" />
          <xsl:value-of select="string-join(subsequence($url-parts, 1, $count-url-parts), '.')" />
          <xsl:text>-thumb.</xsl:text>
          <xsl:value-of select="subsequence($url-parts, $count-url-parts)[last()]" />
        </xsl:attribute>
      </img>
    </a>
  </xsl:template>

</xsl:stylesheet>
