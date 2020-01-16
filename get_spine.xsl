<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:h="http://www.w3.org/1999/xhtml"
  version="1.0">

<xsl:template match="h:a">
  <xsl:message><xsl:value-of select="@href"/></xsl:message>
</xsl:template>

<!-- Recurse -->
<xsl:template match="node()">
  <xsl:apply-templates select="node()"/>
</xsl:template>

</xsl:stylesheet>