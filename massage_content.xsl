<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:epub="http://www.idpf.org/2007/ops"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="h"
  version="1.0">

<!-- Replace '/contents/' in the HREF with just './' -->
<xsl:template match="h:a/@href">
  <xsl:variable name="new-href">
    <xsl:choose>
      <xsl:when test="contains(., '#')">
        <xsl:variable name="search" select="substring-before(., '#')"/>
        <xsl:variable name="after-hash" select="substring-after(., '#')"/>

        <xsl:variable name="file-extension" select="'.html'"/>
        <xsl:variable name="before-hash">
          <xsl:choose>
            <xsl:when test="$file-extension = substring($search, string-length($search) - string-length($file-extension) +1)">
              <xsl:value-of select="$search"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$search"/>
              <xsl:value-of select="$file-extension"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$before-hash"/>#<xsl:value-of select="$after-hash"/>

      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="search" select="."/>
        <xsl:variable name="file-extension" select="'.html'"/>
        <xsl:choose>
          <xsl:when test="$file-extension = substring($search, string-length($search) - string-length($file-extension) +1)">
            <xsl:value-of select="$search"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$search"/>
            <xsl:value-of select="$file-extension"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:attribute name="href">

    <xsl:choose>
      <xsl:when test="starts-with(., 'https://archive.cnx.org/contents/')">
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="$new-href" />
          <xsl:with-param name="replace" select="'https://archive.cnx.org/contents/'" />
          <xsl:with-param name="by" select="''" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:template>


<!-- Just discard Content MathML becaue we do not generate it properly -->
<xsl:template match="m:annotation-xml[@encoding='MathML-Content']">
</xsl:template>


<!-- Recurse -->
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>



<xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
        <xsl:when test="$text = '' or $replace = ''or not($replace)" >
            <!-- Prevent this routine from hanging -->
            <xsl:value-of select="$text" />
        </xsl:when>
        <xsl:when test="contains($text, $replace)">
            <xsl:value-of select="substring-before($text,$replace)" />
            <xsl:value-of select="$by" />
            <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text" select="substring-after($text,$replace)" />
                <xsl:with-param name="replace" select="$replace" />
                <xsl:with-param name="by" select="$by" />
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$text" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>