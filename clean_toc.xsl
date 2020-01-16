<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:epub="http://www.idpf.org/2007/ops"
  xmlns:h="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="h"
  version="1.0">

<xsl:template match="h:body[not(.//h:nav/@epub:type='toc')]">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="node()[not(self::h:ul)]"/>
    <nav epub:type="toc" id="toc" xmlns="http://www.w3.org/1999/xhtml">
      <!-- Unwrap the root-list-with-only-1-child  -->
      <xsl:apply-templates select="h:ul/h:li/h:ul"/>
    </nav>
  </xsl:copy>
</xsl:template>

<!-- Remove the HTML markup in the ToC titles -->
<xsl:template match="h:a/text()">
  <xsl:variable name="r5" select="."/>
  <xsl:variable name="r4">
    <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="$r5" />
        <xsl:with-param name="replace" select="'&lt;span class=&quot;os-text&quot;&gt;'" />
        <xsl:with-param name="by" select="''" />
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="r3">
    <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="$r4" />
        <xsl:with-param name="replace" select="'&lt;span class=&quot;os-divider&quot;&gt;'" />
        <xsl:with-param name="by" select="''" />
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="r2">
    <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="$r3" />
        <xsl:with-param name="replace" select="'&lt;span class=&quot;os-number&quot;&gt;'" />
        <xsl:with-param name="by" select="''" />
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="r1">
    <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="$r2" />
        <xsl:with-param name="replace" select="'&lt;/span&gt;'" />
        <xsl:with-param name="by" select="''" />
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="r0">
    <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="$r1" />
        <xsl:with-param name="replace" select="'&lt;span data-type=&quot;&quot; itemprop=&quot;&quot; class=&quot;os-text&quot;&gt;'" />
        <xsl:with-param name="by" select="''" />
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="$r0"/>
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