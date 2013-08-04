<?xml version="1.0" encoding="UTF-8"?>
<!--
  Generates a FO document from a DocBook XML document using the DocBook XSL stylesheets.
  See http://docbook.sourceforge.net/release/xsl/1.78.1/doc/fo for all parameters.
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:db="http://docbook.org/ns/docbook"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="db">
  <!--
    The absolute URL imports point to system-wide locations by way of this /etc/xml/catalog entry:
  
      <rewriteURI
        uriStartString="http://docbook.sourceforge.net/release/xsl/current"
        rewritePrefix="file:///usr/share/sgml/docbook/xsl-stylesheets-%docbook-style-xsl-version%"/>
  
    %docbook-style-xsl-version% represents the version installed on the system.
  -->
  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl"/>
  <xsl:import href="common.xsl"/>
  <xsl:import href="highlight.xsl"/>
  <xsl:import href="callouts.xsl"/>

  <!-- Enable extensions for FOP version 0.90 and later -->
  <xsl:param name="fop1.extensions">1</xsl:param>

  <!--
    AsciiDoc compat
  -->

  <xsl:template match="processing-instruction('asciidoc-br')">
    <fo:block/>
  </xsl:template>

  <xsl:template match="processing-instruction('asciidoc-hr')">
    <fo:block space-after="1em">
      <fo:leader leader-pattern="rule" rule-thickness="0.5pt" rule-style="solid" leader-length.minimum="100%"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="processing-instruction('asciidoc-pagebreak')">
    <fo:block break-after='page'/>
  </xsl:template>

  <!--
    Font selectors
  -->

  <xsl:template name="pickfont-sans">
    <xsl:text>Arial,sans-serif</xsl:text>
  </xsl:template>

  <xsl:template name="pickfont-serif">
    <xsl:text>Georgia,serif</xsl:text>
  </xsl:template>

  <xsl:template name="pickfont-mono">
    <xsl:text>Liberation Mono,monospace</xsl:text>
  </xsl:template>

  <xsl:template name="pickfont-dingbat">
    <xsl:call-template name="pickfont-sans"/>
  </xsl:template>

  <xsl:template name="pickfont-symbol">
    <xsl:text>Symbol,ZapfDingbats</xsl:text>
  </xsl:template>

  <!--
    Fonts
  -->

  <xsl:param name="body.font.family">
     <xsl:call-template name="pickfont-sans"/>
  </xsl:param>

  <xsl:param name="sans.font.family">
    <xsl:call-template name="pickfont-sans"/>
  </xsl:param>

  <xsl:param name="monospace.font.family">
    <xsl:call-template name="pickfont-mono"/>
  </xsl:param>

  <!--
  <xsl:param name="dingbat.font.family">
    <xsl:call-template name="pickfont-dingbat"/>
  </xsl:param>

  <xsl:param name="symbol.font.family">
    <xsl:call-template name="pickfont-symbol"/>
  </xsl:param>
  -->

  <xsl:param name="title.font.family">
    <xsl:call-template name="pickfont-serif"/>
  </xsl:param>

  <!--
    Text properties
  -->

  <xsl:param name="hyphenate">false</xsl:param>
  <xsl:param name="alignment">left</xsl:param>
  <xsl:param name="line-height">1.5</xsl:param>
  <xsl:param name="alignment">justify</xsl:param>
  <xsl:param name="body.font.master">12</xsl:param>
  <xsl:param name="body.font.size">
    <xsl:value-of select="$body.font.master"/><xsl:text>pt</xsl:text>
  </xsl:param>

  <xsl:attribute-set name="root.properties">
    <xsl:attribute name="color"><xsl:value-of select="$text.color"/></xsl:attribute>
  </xsl:attribute-set>

  <!-- normal.para.spacing is the only attribute set applied to all paragraphs -->
  <xsl:attribute-set name="normal.para.spacing">
    <xsl:attribute name="space-before.optimum">0</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0</xsl:attribute>
    <xsl:attribute name="space-after.optimum">1em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">1.2em</xsl:attribute>
    <!--
    <xsl:attribute name="color"><xsl:value-of select="$text.color"/></xsl:attribute>
    -->
  </xsl:attribute-set>

  <xsl:attribute-set name="monospace.properties">
    <xsl:attribute name="background-color">#EEEEEE</xsl:attribute>
    <!--
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 0.9"/><xsl:text>pt</xsl:text>
    </xsl:attribute>
    -->
    <xsl:attribute name="padding">.3em .25em .1em .25em</xsl:attribute>
    <!--
    <xsl:attribute name="font-family"><xsl:value-of select="$monospace.font.family"/></xsl:attribute>
    -->
  </xsl:attribute-set>

  <xsl:attribute-set name="verbatim.properties">
    <xsl:attribute name="border-top-style">dotted</xsl:attribute>
    <xsl:attribute name="border-bottom-style">dotted</xsl:attribute>
    <xsl:attribute name="border-width">1pt</xsl:attribute>
    <xsl:attribute name="border-color">#BFBFBF</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0</xsl:attribute>
    <xsl:attribute name="space-before.optimum">.2em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">.4em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">1em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">1.2em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">1.4em</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:attribute name="wrap-option">wrap</xsl:attribute>
    <xsl:attribute name="white-space-collapse">false</xsl:attribute>
    <xsl:attribute name="white-space-treatment">preserve</xsl:attribute>
    <xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
    <xsl:attribute name="text-align">start</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="monospace.verbatim.properties"
                     use-attribute-sets="verbatim.properties monospace.properties">
    <!--
    <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
    -->
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="text-align">start</xsl:attribute>
    <xsl:attribute name="wrap-option">wrap</xsl:attribute>
    <!--
    <xsl:attribute name="hyphenation-character">&#x25BA;</xsl:attribute>
    -->
  </xsl:attribute-set>

  <!-- shade.verbatim.style is added to listings when shade.verbatim is enabled -->
  <xsl:param name="shade.verbatim">1</xsl:param>

  <xsl:attribute-set name="shade.verbatim.style">
    <xsl:attribute name="background-color">transparent</xsl:attribute>
    <!--
    <xsl:attribute name="background-color">
      <xsl:choose>
        <xsl:when test="ancestor::db:note">
          <xsl:text>#D6DEE0</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor::db:caution">
          <xsl:text>#FAF8ED</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor::db:important">
          <xsl:text>#E1EEF4</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor::db:warning">
          <xsl:text>#FAF8ED</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor::db:tip">
          <xsl:text>#D5E1D5</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>#FFF</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    -->
    <xsl:attribute name="color"><xsl:value-of select="$text.color"/></xsl:attribute>
    <!--
    <xsl:attribute name="color">
      <xsl:choose>
        <xsl:when test="ancestor::db:note">
          <xsl:text>#334558</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor::db:caution">
          <xsl:text>#334558</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor::db:important">
          <xsl:text>#334558</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor::db:warning">
          <xsl:text>#334558</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor::db:tip">
          <xsl:text>#334558</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>#222</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    -->
    <xsl:attribute name="padding">1em .5em .75em .5em</xsl:attribute>
    <!-- make sure block it aligns with block title -->
    <xsl:attribute name="margin-left"><xsl:value-of select="$title.margin.left"/></xsl:attribute>
  </xsl:attribute-set>

  <!--
    Page layout
  -->

  <xsl:param name="paper.type">A4</xsl:param> <!-- alternative size is USletter -->
  <xsl:param name="headers.on.blank.pages">1</xsl:param>
  <xsl:param name="footers.on.blank.pages">1</xsl:param>
  <xsl:param name="page.margin.top">10mm</xsl:param> <!-- top margin of page -->
  <xsl:param name="page.margin.bottom">10mm</xsl:param> <!-- top margin of page -->
  <xsl:param name="page.margin.inner">20mm</xsl:param> <!-- side margin of page (left, towards binding) -->
  <xsl:param name="page.margin.outer">20mm</xsl:param> <!-- side margin of page (right, away from binding) -->
  <xsl:param name="body.margin.top">15mm</xsl:param> <!-- top margin of content -->
  <xsl:param name="body.margin.bottom">15mm</xsl:param> <!-- bottom margin of content -->
  <xsl:param name="body.margin.inner">4mm</xsl:param> <!-- side margin of content (left, towards binding) -->
  <xsl:param name="body.margin.outer">6mm</xsl:param> <!-- side margin of content (right, away from binding) -->
  <xsl:param name="body.start.indent">0</xsl:param> <!-- text indentation -->
  <xsl:param name="body.end.indent">0</xsl:param> <!-- text recess from right -->
  <xsl:param name="region.before.extent">10mm</xsl:param> <!-- height of page header -->
  <xsl:param name="region.after.extent">10mm</xsl:param> <!-- height of page footer -->

  <!--
    Table of Contents
  -->

  <xsl:param name="bridgehead.in.toc">0</xsl:param>
  <xsl:param name="toc.section.depth">2</xsl:param>

  <xsl:template name="toc.line">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>

    <xsl:variable name="label">
      <xsl:apply-templates select="." mode="label.markup"/>
    </xsl:variable>

    <fo:block text-align-last="justify" end-indent="{$toc.indent.width}pt"
              last-line-end-indent="-{$toc.indent.width}pt">
      <fo:inline keep-with-next.within-line="always">
        <fo:basic-link internal-destination="{$id}" color="#005498">
          <!-- Chapter titles should be bold. -->
          <!--
          <xsl:choose>
            <xsl:when test="local-name(.) = 'chapter'">
              <xsl:attribute name="font-weight">bold</xsl:attribute>
            </xsl:when>
          </xsl:choose>
          -->
          <xsl:if test="$label != ''">
            <!--
            <xsl:value-of select="'Chapter '"/>
            -->
            <xsl:copy-of select="$label"/>
            <xsl:value-of select="$autotoc.label.separator"/>
          </xsl:if>
          <xsl:apply-templates select="." mode="titleabbrev.markup"/>
        </fo:basic-link>
      </fo:inline>
      <fo:inline keep-together.within-line="always">
        <xsl:text> </xsl:text>
        <fo:leader leader-pattern="dots" leader-pattern-width="3pt"
                   leader-alignment="reference-area"
                   keep-with-next.within-line="always"/>
          <xsl:text> </xsl:text>
          <fo:basic-link internal-destination="{$id}" color="#005498">
            <fo:page-number-citation ref-id="{$id}"/>
        </fo:basic-link>
      </fo:inline>
    </fo:block>
  </xsl:template>

  <!--
    Blocks
   -->

  <xsl:attribute-set name="formal.object.properties">
    <xsl:attribute name="space-before.minimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-before.optimum">1em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">1.2em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">1em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">1.2em</xsl:attribute>
    <!-- Make examples, tables etc. break across pages -->
    <xsl:attribute name="keep-together.within-column">auto</xsl:attribute>
  </xsl:attribute-set>

  <xsl:param name="formal.title.placement">
    figure after
    example before
    table before
  </xsl:param>

  <xsl:attribute-set name="formal.title.properties">
    <xsl:attribute name="color"><xsl:value-of select="$caption.color"/></xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="*" mode="admon.graphic.width">
    <xsl:text>36pt</xsl:text>
  </xsl:template>

  <xsl:attribute-set name="admonition.properties">
    <xsl:attribute name="color">#6F6F6F</xsl:attribute>
    <xsl:attribute name="padding-left">18pt</xsl:attribute>
    <xsl:attribute name="border-left-width">.75pt</xsl:attribute>
    <xsl:attribute name="border-left-style">solid</xsl:attribute>
    <xsl:attribute name="border-left-color"><xsl:value-of select="$border.color"/></xsl:attribute>
    <xsl:attribute name="margin-left">0</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="graphical.admonition.properties">
    <xsl:attribute name="margin-left">12pt</xsl:attribute>
    <xsl:attribute name="margin-right">12pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="example.properties" use-attribute-sets="formal.object.properties">
    <xsl:attribute name="border-width">1pt</xsl:attribute>
    <xsl:attribute name="border-style">solid</xsl:attribute>
    <xsl:attribute name="border-color">#E6E6E6</xsl:attribute>
    <xsl:attribute name="padding-top">12pt</xsl:attribute>
    <xsl:attribute name="padding-right">12pt</xsl:attribute>
    <xsl:attribute name="padding-bottom">0</xsl:attribute>
    <xsl:attribute name="padding-left">12pt</xsl:attribute>
    <xsl:attribute name="margin-left">0</xsl:attribute>
    <xsl:attribute name="margin-right">0</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="sidebar.properties" use-attribute-sets="formal.object.properties">
    <xsl:attribute name="border-style">solid</xsl:attribute>
    <xsl:attribute name="border-width">1pt</xsl:attribute>
    <xsl:attribute name="border-color">#D9D9D9</xsl:attribute>
    <xsl:attribute name="background-color">#F2F2F2</xsl:attribute>
    <xsl:attribute name="padding-start">16pt</xsl:attribute>
    <xsl:attribute name="padding-end">16pt</xsl:attribute>
    <xsl:attribute name="padding-top">18pt</xsl:attribute>
    <xsl:attribute name="padding-bottom">0</xsl:attribute>
  </xsl:attribute-set>
 
  <xsl:attribute-set name="sidebar.title.properties">
    <xsl:attribute name="font-family"><xsl:value-of select="$title.fontset"/></xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$caption.color"/></xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.6"/><xsl:text>pt</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="margin-bottom">
      <xsl:value-of select="$body.font.master"/><xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <!--
    Tables
  -->

  <xsl:attribute-set name="table.cell.padding">
    <xsl:attribute name="padding-left">4pt</xsl:attribute>
    <xsl:attribute name="padding-right">4pt</xsl:attribute>
    <xsl:attribute name="padding-top">2pt</xsl:attribute>
    <xsl:attribute name="padding-bottom">2pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:param name="table.frame.border.thickness">0.3pt</xsl:param>
  <xsl:param name="table.cell.border.thickness">0.15pt</xsl:param>
  <xsl:param name="table.cell.border.color">#5c5c4f</xsl:param>
  <xsl:param name="table.frame.border.color">#5c5c4f</xsl:param>
  <xsl:param name="table.cell.border.right.color">white</xsl:param>
  <xsl:param name="table.cell.border.left.color">white</xsl:param>
  <xsl:param name="table.frame.border.right.color">white</xsl:param>
  <xsl:param name="table.frame.border.left.color">white</xsl:param>

  <xsl:attribute-set name="table.cell.padding">
    <xsl:attribute name="padding-left">4pt</xsl:attribute>
    <xsl:attribute name="padding-right">4pt</xsl:attribute>
    <xsl:attribute name="padding-top">2pt</xsl:attribute>
    <xsl:attribute name="padding-bottom">2pt</xsl:attribute>
  </xsl:attribute-set>

  <!--
    Graphics
  -->

  <!-- graphicsize.extension only relevant for html output -->
  <!--
  <xsl:param name="graphicsize.extension">1</xsl:param>
  -->
  <xsl:param name="default.image.width">6.3in</xsl:param>
  <xsl:param name="default.inline.image.height">1em</xsl:param>

  <xsl:template name="process.image">
    <!-- if image is wider than the page, shrink it down to default.image.width -->
    <xsl:variable name="scalefit">
      <xsl:choose>
        <xsl:when test="$ignore.image.scaling != 0">0</xsl:when>
        <xsl:when test="@contentwidth">0</xsl:when>
        <xsl:when test="@contentdepth and @contentdepth != '100%'">0</xsl:when>
        <xsl:when test="@scale">0</xsl:when>
        <xsl:when test="@scalefit">
          <xsl:value-of select="@scalefit"/>
        </xsl:when>
        <xsl:when test="@width or @depth">1</xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="scale">
      <xsl:choose>
        <xsl:when test="$ignore.image.scaling != 0">0</xsl:when>
        <xsl:when test="@contentwidth or @contentdepth">1.0</xsl:when>
        <xsl:when test="@scale">
          <xsl:value-of select="@scale div 100.0"/>
        </xsl:when>
        <xsl:otherwise>1.0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="filename">
      <xsl:choose>
        <xsl:when test="local-name(.) = 'graphic' or local-name(.) = 'inlinegraphic'">
          <xsl:call-template name="mediaobject.filename">
            <xsl:with-param name="object" select="."/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="mediaobject.filename">
            <xsl:with-param name="object" select=".."/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="content-type">
      <xsl:if test="@format">
         <xsl:call-template name="graphic.format.content-type">
           <xsl:with-param name="format" select="@format"/>
         </xsl:call-template>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="bgcolor">
      <xsl:call-template name="pi.dbfo_background-color">
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
    </xsl:variable>

    <fo:external-graphic>
      <xsl:attribute name="src">
        <xsl:call-template name="fo-external-image">
          <xsl:with-param name="filename">
            <xsl:if test="$img.src.path != '' and not(starts-with($filename, '/')) and not(contains($filename, '://'))">
              <xsl:value-of select="$img.src.path"/>
            </xsl:if>
            <xsl:value-of select="$filename"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:attribute name="width">
        <xsl:choose>
          <xsl:when test="$ignore.image.scaling != 0">auto</xsl:when>
          <xsl:when test="contains(@width,'%')">
            <xsl:value-of select="@width"/>
          </xsl:when>
          <xsl:when test="@width and not(@width = '')">
            <xsl:call-template name="length-spec">
              <xsl:with-param name="length" select="@width"/>
              <xsl:with-param name="default.units" select="'px'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="not(@depth) and not(ancestor::inlinemediaobject) and $default.image.width != ''">
            <xsl:call-template name="length-spec">
              <xsl:with-param name="length" select="$default.image.width"/>
              <xsl:with-param name="default.units" select="'px'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>auto</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:attribute name="height">
        <xsl:choose>
          <xsl:when test="$ignore.image.scaling != 0">auto</xsl:when>
          <xsl:when test="contains(@depth,'%')">
            <xsl:value-of select="@depth"/>
          </xsl:when>
          <xsl:when test="@depth">
            <xsl:call-template name="length-spec">
              <xsl:with-param name="length" select="@depth"/>
              <xsl:with-param name="default.units" select="'px'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="ancestor::inlinemediaobject">
            <xsl:call-template name="length-spec">
              <xsl:with-param name="length" select="$default.inline.image.height"/>
              <xsl:with-param name="default.units" select="'px'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>auto</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:attribute name="content-width">
        <xsl:choose>
          <xsl:when test="$ignore.image.scaling != 0">auto</xsl:when>
          <xsl:when test="contains(@contentwidth,'%')">
            <xsl:value-of select="@contentwidth"/>
          </xsl:when>
          <xsl:when test="@contentwidth">
            <xsl:call-template name="length-spec">
              <xsl:with-param name="length" select="@contentwidth"/>
              <xsl:with-param name="default.units" select="'px'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="number($scale) != 1.0">
            <xsl:value-of select="$scale * 100"/>
            <xsl:text>%</xsl:text>
          </xsl:when>
          <xsl:when test="$scalefit = 1">scale-to-fit</xsl:when>
          <xsl:otherwise>scale-down-to-fit</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:attribute name="content-height">
        <xsl:choose>
          <xsl:when test="$ignore.image.scaling != 0">auto</xsl:when>
          <xsl:when test="contains(@contentdepth,'%')">
             <xsl:value-of select="@contentdepth"/>
          </xsl:when>
          <xsl:when test="@contentdepth">
             <xsl:call-template name="length-spec">
               <xsl:with-param name="length" select="@contentdepth"/>
               <xsl:with-param name="default.units" select="'px'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="number($scale) != 1.0">
            <xsl:value-of select="$scale * 100"/>
            <xsl:text>%</xsl:text>
          </xsl:when>
          <xsl:when test="$scalefit = 1">scale-to-fit</xsl:when>
          <xsl:otherwise>scale-down-to-fit</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:if test="$content-type != ''">
        <xsl:attribute name="content-type">
          <xsl:value-of select="concat('content-type:',$content-type)"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="$bgcolor != ''">
        <xsl:attribute name="background-color">
          <xsl:value-of select="$bgcolor"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="@align">
        <xsl:attribute name="text-align">
          <xsl:value-of select="@align"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="@valign">
        <xsl:attribute name="display-align">
          <xsl:choose>
            <xsl:when test="@valign = 'top'">before</xsl:when>
            <xsl:when test="@valign = 'middle'">center</xsl:when>
            <xsl:when test="@valign = 'bottom'">after</xsl:when>
            <xsl:otherwise>auto</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
    </fo:external-graphic>
  </xsl:template>

  <!--
    Titles
  -->

  <xsl:attribute-set name="section.title.properties">
    <xsl:attribute name="font-family"><xsl:value-of select="$title.fontset"/></xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <!-- font size is calculated dynamically by section.heading template -->
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-before.optimum">1.0em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">1.2em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">1.0em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">1.2em</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
    <!-- make sure block it aligns with block title -->
    <xsl:attribute name="start-indent"><xsl:value-of select="$title.margin.left"/></xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="color"><xsl:value-of select="$section.title.color"/></xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.6"/><xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level2.properties">
    <xsl:attribute name="color"><xsl:value-of select="$section.title.color"/></xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.4"/><xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level3.properties">
    <xsl:attribute name="color"><xsl:value-of select="$section.title.color"/></xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.3"/><xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level4.properties">
    <xsl:attribute name="color"><xsl:value-of select="$section.title.color"/></xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.2"/><xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level5.properties">
    <xsl:attribute name="color"><xsl:value-of select="$section.title.color"/></xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.1"/><xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level6.properties">
    <xsl:attribute name="color"><xsl:value-of select="$section.title.color"/></xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master"/><xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="component.title.properties">
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    <xsl:attribute name="space-before.optimum">
      <xsl:value-of select="concat($body.font.master, 'pt')"/>
    </xsl:attribute>
    <xsl:attribute name="space-before.minimum">
      <xsl:value-of select="concat($body.font.master, 'pt')"/>
    </xsl:attribute>
    <xsl:attribute name="space-before.maximum">
      <xsl:value-of select="concat($body.font.master, 'pt')"/>
    </xsl:attribute>
    <xsl:attribute name="space-after.optimum">
      <xsl:value-of select="concat($body.font.master, 'pt')"/>
    </xsl:attribute>
    <xsl:attribute name="space-after.minimum">
      <xsl:value-of select="concat($body.font.master, 'pt')"/>
    </xsl:attribute>
    <xsl:attribute name="space-after.maximum">
      <xsl:value-of select="concat($body.font.master, 'pt')"/>
    </xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:attribute name="color">
      <xsl:choose>
        <xsl:when test="not(parent::db:chapter | parent::db:article | parent::db:appendix)">
          <xsl:value-of select="$title.color"/>
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="text-align">
      <xsl:choose>
        <xsl:when test="((parent::db:article | parent::db:articleinfo) and not(ancestor::db:book) and not(self::db:bibliography)) or (parent::db:slides | parent::db:slidesinfo)">center</xsl:when>
        <xsl:otherwise>left</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="start-indent">
      <xsl:value-of select="$title.margin.left"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="formalpara/title">
    <xsl:variable name="titleStr">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:variable name="lastChar">
      <xsl:if test="$titleStr != ''">
        <xsl:value-of select="substring($titleStr,string-length($titleStr),1)"/>
      </xsl:if>
    </xsl:variable>
  
    <fo:inline font-weight="bold"
               color="{$caption.color}"
               keep-with-next.within-line="always">
      <xsl:copy-of select="$titleStr"/>
      <xsl:if test="$lastChar != ''
                    and not(contains($runinhead.title.end.punct, $lastChar))">
        <xsl:value-of select="$runinhead.default.title.end.punct"/>
      </xsl:if>
    </fo:inline>
  </xsl:template>

  <!--
    Anchors & Links
  -->

  <xsl:attribute-set name="xref.properties">
    <xsl:attribute name="color"><xsl:value-of select="$link.color"/></xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="simple.xlink.properties">
    <xsl:attribute name="color"><xsl:value-of select="$link.color"/></xsl:attribute>
  </xsl:attribute-set>

  <!--
    Lists
  -->

  <xsl:param name="qandadiv.autolabel">0</xsl:param>
  <xsl:param name="variablelist.as.blocks">1</xsl:param>

  <xsl:attribute-set name="list.block.properties">
    <xsl:attribute name="margin-left">0.4em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="list.block.spacing">
    <xsl:attribute name="space-before.optimum">1.2em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">1em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">1.4em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">1.2em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">1em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">1.4em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="list.item.spacing">
    <xsl:attribute name="space-before.optimum">0.5em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.2em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.8em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="variablelist.term.properties">
    <xsl:attribute name="font-weight">bold</xsl:attribute> 
  </xsl:attribute-set>

  <!--
    Title pages
  -->

  <xsl:param name="titlepage.color">#6F6F6F</xsl:param>
  <!--
  <xsl:param name="titlepage.color" select="$title.color"/>
  -->

  <xsl:attribute-set name="book.titlepage.recto.style">
    <xsl:attribute name="font-family"><xsl:value-of select="$title.fontset"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$titlepage.color"/></xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="chapter.titlepage.recto.style">
    <xsl:attribute name="color"><xsl:value-of select="$chapter.title.color"/></xsl:attribute>
    <xsl:attribute name="background-color">white</xsl:attribute>
    <xsl:attribute name="font-size">24pt</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
    <!--xsl:attribute name="wrap-option">no-wrap</xsl:attribute-->
    <xsl:attribute name="padding-left">1em</xsl:attribute>
    <xsl:attribute name="padding-right">1em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="preface.titlepage.recto.style" use-attribute-sets="chapter.titlepage.recto.style">
    <xsl:attribute name="font-family"><xsl:value-of select="$title.fontset"/></xsl:attribute>
    <!--
    <xsl:attribute name="color">#4a5d75</xsl:attribute>
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    -->
  </xsl:attribute-set>

  <xsl:attribute-set name="part.titlepage.recto.style">
    <xsl:attribute name="color"><xsl:value-of select="$title.color"/></xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="title" mode="book.titlepage.recto.auto.mode">
    <fo:block xsl:use-attribute-sets="book.titlepage.recto.style" text-align="center" font-size="24.8832pt" space-before="18.6624pt" color="{$text.color}">
      <xsl:call-template name="division.title">
        <xsl:with-param name="node" select="ancestor-or-self::book[1]"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <xsl:template match="title" mode="chapter.titlepage.recto.auto.mode">
    <fo:block xsl:use-attribute-sets="chapter.titlepage.recto.style">
      <xsl:call-template name="component.title">
        <xsl:with-param name="node" select="ancestor-or-self::chapter[1]"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <xsl:template match="revision" mode="book.titlepage.recto.auto.mode">
    <fo:block xsl:use-attribute-sets="book.titlepage.recto.style" text-align="center" font-size="14.4pt" space-before="1in" font-family="{$title.fontset}">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Revision'"/>
      </xsl:call-template> 
      <xsl:call-template name="gentext.space"/>
      <xsl:apply-templates select="revnumber" mode="titlepage.mode"/>
    </fo:block>
    <fo:block xsl:use-attribute-sets="book.titlepage.recto.style" text-align="center" font-size="14.4pt" font-family="{$title.fontset}">
      <xsl:apply-templates select="date" mode="titlepage.mode"/> 
    </fo:block>
  </xsl:template>

  <xsl:template name="book.titlepage.recto">
    <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/title"/>
    <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/author"/>
    <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/revhistory/revision[1]"/>
    <!--
    <xsl:apply-templates mode="titlepage.mode" select="bookinfo/revhistory"/>
    -->
  </xsl:template>

  <xsl:template name="book.titlepage.before.verso"/>
  <xsl:template name="book.titlepage.verso"/>

  <xsl:template name="preface.titlepage.recto">
    <fo:block xsl:use-attribute-sets="preface.titlepage.recto.style">
      <xsl:call-template name="component.title">
        <xsl:with-param name="node" select="ancestor-or-self::preface[1]"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <xsl:template name="table.of.contents.titlepage.recto">
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="table.of.contents.titlepage.recto.style" space-before.minimum="1em" space-before.optimum="1.5em" space-before.maximum="2em" space-after="0.5em" start-indent="0pt" font-size="17.28pt" font-family="{$title.fontset}" color="{$title.color}">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'TableofContents'"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <xsl:template match="title" mode="appendix.titlepage.recto.auto.mode">
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="appendix.titlepage.recto.style" margin-left="{$title.margin.left}" font-size="24.8832pt" font-family="{$title.fontset}">
      <xsl:call-template name="component.title">
        <xsl:with-param name="node" select="ancestor-or-self::appendix[1]"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <xsl:template name="dedication.titlepage.recto">
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="dedication.titlepage.recto.style" margin-left="{$title.margin.left}" font-size="24.8832pt" font-family="{$title.fontset}">
      <xsl:call-template name="component.title">
        <xsl:with-param name="node" select="ancestor-or-self::dedication[1]"/>
      </xsl:call-template>
    </fo:block>
    <xsl:choose>
      <xsl:when test="dedicationinfo/subtitle">
        <xsl:apply-templates mode="dedication.titlepage.recto.auto.mode" select="dedicationinfo/subtitle"/>
      </xsl:when>
      <xsl:when test="docinfo/subtitle">
        <xsl:apply-templates mode="dedication.titlepage.recto.auto.mode" select="docinfo/subtitle"/>
      </xsl:when>
      <xsl:when test="info/subtitle">
        <xsl:apply-templates mode="dedication.titlepage.recto.auto.mode" select="info/subtitle"/>
      </xsl:when>
      <xsl:when test="subtitle">
        <xsl:apply-templates mode="dedication.titlepage.recto.auto.mode" select="subtitle"/>
      </xsl:when>
    </xsl:choose>
  
    <xsl:apply-templates mode="dedication.titlepage.recto.auto.mode" select="dedicationinfo/itermset"/>
    <xsl:apply-templates mode="dedication.titlepage.recto.auto.mode" select="docinfo/itermset"/>
    <xsl:apply-templates mode="dedication.titlepage.recto.auto.mode" select="info/itermset"/>
  </xsl:template>

  <xsl:template name="bibliography.titlepage.recto">
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="bibliography.titlepage.recto.style" margin-left="{$title.margin.left}" font-size="24.8832pt" font-family="{$title.fontset}">
      <xsl:call-template name="component.title">
        <xsl:with-param name="node" select="ancestor-or-self::bibliography[1]"/>
      </xsl:call-template>
    </fo:block>
    <xsl:choose>
      <xsl:when test="bibliographyinfo/subtitle">
        <xsl:apply-templates mode="bibliography.titlepage.recto.auto.mode" select="bibliographyinfo/subtitle"/>
      </xsl:when>
      <xsl:when test="docinfo/subtitle">
        <xsl:apply-templates mode="bibliography.titlepage.recto.auto.mode" select="docinfo/subtitle"/>
      </xsl:when>
      <xsl:when test="info/subtitle">
        <xsl:apply-templates mode="bibliography.titlepage.recto.auto.mode" select="info/subtitle"/>
      </xsl:when>
      <xsl:when test="subtitle">
        <xsl:apply-templates mode="bibliography.titlepage.recto.auto.mode" select="subtitle"/>
      </xsl:when>
    </xsl:choose>
  
    <xsl:apply-templates mode="bibliography.titlepage.recto.auto.mode" select="bibliographyinfo/itermset"/>
    <xsl:apply-templates mode="bibliography.titlepage.recto.auto.mode" select="docinfo/itermset"/>
    <xsl:apply-templates mode="bibliography.titlepage.recto.auto.mode" select="info/itermset"/>
  </xsl:template>

  <xsl:template name="glossary.titlepage.recto">
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="glossary.titlepage.recto.style" margin-left="{$title.margin.left}" font-size="24.8832pt" font-family="{$title.fontset}">
      <xsl:call-template name="component.title">
        <xsl:with-param name="node" select="ancestor-or-self::glossary[1]"/>
      </xsl:call-template>
    </fo:block>
    <xsl:choose>
      <xsl:when test="glossaryinfo/subtitle">
        <xsl:apply-templates mode="glossary.titlepage.recto.auto.mode" select="glossaryinfo/subtitle"/>
      </xsl:when>
      <xsl:when test="docinfo/subtitle">
        <xsl:apply-templates mode="glossary.titlepage.recto.auto.mode" select="docinfo/subtitle"/>
      </xsl:when>
      <xsl:when test="info/subtitle">
        <xsl:apply-templates mode="glossary.titlepage.recto.auto.mode" select="info/subtitle"/>
      </xsl:when>
      <xsl:when test="subtitle">
        <xsl:apply-templates mode="glossary.titlepage.recto.auto.mode" select="subtitle"/>
      </xsl:when>
    </xsl:choose>
  
    <xsl:apply-templates mode="glossary.titlepage.recto.auto.mode" select="glossaryinfo/itermset"/>
    <xsl:apply-templates mode="glossary.titlepage.recto.auto.mode" select="docinfo/itermset"/>
    <xsl:apply-templates mode="glossary.titlepage.recto.auto.mode" select="info/itermset"/>
  </xsl:template>

  <xsl:template name="index.titlepage.recto">
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="index.titlepage.recto.style" margin-left="0pt" font-size="24.8832pt" font-family="{$title.fontset}">
      <xsl:call-template name="component.title">
        <xsl:with-param name="node" select="ancestor-or-self::index[1]"/>
        <xsl:with-param name="pagewide" select="1"/>
      </xsl:call-template>
    </fo:block>
    <xsl:choose>
      <xsl:when test="indexinfo/subtitle">
        <xsl:apply-templates mode="index.titlepage.recto.auto.mode" select="indexinfo/subtitle"/>
      </xsl:when>
      <xsl:when test="docinfo/subtitle">
        <xsl:apply-templates mode="index.titlepage.recto.auto.mode" select="docinfo/subtitle"/>
      </xsl:when>
      <xsl:when test="info/subtitle">
        <xsl:apply-templates mode="index.titlepage.recto.auto.mode" select="info/subtitle"/>
      </xsl:when>
      <xsl:when test="subtitle">
        <xsl:apply-templates mode="index.titlepage.recto.auto.mode" select="subtitle"/>
      </xsl:when>
    </xsl:choose>
  
    <xsl:apply-templates mode="index.titlepage.recto.auto.mode" select="indexinfo/itermset"/>
    <xsl:apply-templates mode="index.titlepage.recto.auto.mode" select="docinfo/itermset"/>
    <xsl:apply-templates mode="index.titlepage.recto.auto.mode" select="info/itermset"/>
  </xsl:template>

  <!--
    Footnotes
  -->

  <xsl:param name="footnote.number.format">1</xsl:param>
  <xsl:param name="footnote.number.symbols"/>

  <xsl:param name="footnote.font.size">
    <xsl:value-of select="$body.font.master * 0.8"/><xsl:text>pt</xsl:text>
  </xsl:param>

  <xsl:attribute-set name="footnote.mark.properties">
    <!-- override font-family for mark since we don't need full font set -->
    <xsl:attribute name="font-family"><xsl:value-of select="$body.font.family"/></xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 0.8"/><xsl:text>pt</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$link.color"/></xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="padding">0 1pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="footnote.properties">
    <!-- force color since it will otherwise inherit from location of footnote text -->
    <xsl:attribute name="color"><xsl:value-of select="$text.color"/></xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="footnote.sep.leader.properties">
    <xsl:attribute name="color"><xsl:value-of select="$border.color"/></xsl:attribute>
    <xsl:attribute name="leader-pattern">rule</xsl:attribute>
    <xsl:attribute name="leader-length">2in</xsl:attribute>
    <xsl:attribute name="rule-thickness">0.5pt</xsl:attribute>
  </xsl:attribute-set>

  <!-- Index does not use normal.para.spacing, so set text.color explicitly -->
  <!--
  <xsl:attribute-set name="index.div.title.properties">
    <xsl:attribute name="color"><xsl:value-of select="$text.color"/></xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="index.entry.properties">
    <xsl:attribute name="color"><xsl:value-of select="$text.color"/></xsl:attribute>
  </xsl:attribute-set>
  -->

</xsl:stylesheet>
