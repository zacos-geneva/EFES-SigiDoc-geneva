<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="response" mode="text-index">
    <table class="tablesorter">
      <thead>
        <tr>
          <th>Filename</th>
          <th>XML ID</th>
          <th>Title</th>
          <th>Author</th>
          <th>Editor</th>
          <th>Publication Date</th>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates mode="text-index" select="result" />
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="result[not(doc)]" mode="text-index">
    <p>There are no files indexed from webapps/ROOT/content/xml/tei!
    Put some there, index them from the admin page, and this page will
    become much more interesting.</p>
  </xsl:template>

  <xsl:template match="result/doc" mode="text-index">
    <tr>
      <xsl:apply-templates mode="text-index" select="str[@name='file_path']" />
      <td><xsl:value-of select="str[@name='document_id']" /></td>
      <td><xsl:value-of select="string-join(arr[@name='document_title']/str, '; ')" /></td>
      <td><xsl:value-of select="string-join(arr[@name='author']/str, '; ')" /></td>
      <td><xsl:value-of select="string-join(arr[@name='editor']/str, '; ')" /></td>
      <td><xsl:value-of select="str[@name='publication_date']" /></td>
    </tr>
  </xsl:template>

  <xsl:template match="str[@name='file_path']" mode="text-index">
    <xsl:variable name="filename" select="substring-after(., '/')" />
    <td>
      <a href="{kiln:url-for-match($match_id, ($filename), 0)}">
        <xsl:value-of select="$filename" />
      </a>
    </td>
  </xsl:template>

</xsl:stylesheet>
