<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    
    <xsl:template match="files" mode="text-index">
        <table class="tablesorter">
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Structure</th>
                    <th>Editor</th>
                </tr>
            </thead>
            <tbody>
                <xsl:apply-templates mode="text-index" select="file" />
            </tbody>
        </table>
    </xsl:template>
    
    <xsl:template match="files[not(file)]" mode="text-index">
        <p>There are no TEI files in webapps/ROOT/content/xml/tei! Put
            some there and this page will become much more interesting.</p>
    </xsl:template>
    
    <xsl:template match="file[starts-with(@path, 'samples/')]" mode="text-index">
        <xsl:variable name="path" select="substring-after(@path, 'samples/')" />
        <tr>
            <td><xsl:value-of select="substring-before($path,'.html')"/>: <xsl:value-of select="@title" /></td>
            <td><a href="iospe/{$path}">IOSPE</a>|<a href="inslib/{$path}">InsLib</a></td>
            <td><xsl:value-of select="@editor" /></td>
        </tr>
    </xsl:template>
    
    <xsl:template match="file" mode="text-index" />
    
</xsl:stylesheet>

