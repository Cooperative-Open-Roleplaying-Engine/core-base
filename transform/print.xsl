<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:output method="xml"/>
<xsl:strip-space elements="*"/>
<xsl:key name="titles" match="*" use="@ref-id"/>

<!-- Variables -->
<xsl:variable name="contentBase">../content/</xsl:variable>
<xsl:variable name="pictureBase">../pictures/</xsl:variable>
<xsl:variable name="defaultHeaderFont">Cinzel</xsl:variable>
<xsl:variable name="defaultContentFont">Crimson Text</xsl:variable>
<xsl:variable name="defaultContentSize">9pt</xsl:variable>

<!-- Templates -->
<xsl:template name="headerBlock">
	<xsl:param name="content"/>
	<xsl:param name="level"/>
	<xsl:param name="value"/>
	
	<xsl:variable name="fontSize">
		<xsl:choose>
			<xsl:when test="number($level) = 2">120%</xsl:when>
			<xsl:when test="number($level) = 3">100%</xsl:when>
			<xsl:otherwise>150%</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="spaceBefore">
		<xsl:choose>
			<xsl:when test="number($level) = 2">3mm</xsl:when>
			<xsl:when test="number($level) = 3">2mm</xsl:when>
			<xsl:otherwise>5mm</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$value">
			<fo:block font-size="{$fontSize}" font-family="{$defaultContentFont}" font-weight="bold" keep-with-next="always" space-before="{$spaceBefore}" space-after="0.5mm" text-align-last="justify" id="{generate-id(.)}">
				<xsl:value-of select="$content"/>
				<fo:leader/>
				<xsl:value-of select="$value"/>
			</fo:block>
		</xsl:when>
		<xsl:otherwise>
			<fo:block font-size="{$fontSize}" font-family="{$defaultContentFont}" font-weight="bold" keep-with-next="always" space-before="{$spaceBefore}" space-after="0.5mm" id="{generate-id(.)}">
				<xsl:value-of select="$content"/>
			</fo:block>
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>

<xsl:template name="definitionBlock">
	<xsl:param name="title"/>
	<xsl:param name="content"/>
	<xsl:param name="abbreviation"/>
	<xsl:param name="ref-id"/>
	
	<xsl:choose>
		<xsl:when test="$abbreviation">
			<fo:block id="{$ref-id}" font-family="{$defaultContentFont}" font-size="{$defaultContentSize}" font-weight="bold" text-align-last="justify" keep-with-next="always" space-before="2mm">
				<xsl:value-of select="$title" />
				<fo:leader/>
				[<xsl:value-of select="$abbreviation"/>]
			</fo:block>
		</xsl:when>
		<xsl:otherwise>
			<fo:block id="{$ref-id}" font-weight="bold" keep-with-next="always" space-before="2mm">
				<xsl:value-of select="$title"/>
			</fo:block>
		</xsl:otherwise>
	</xsl:choose>
	<fo:block font-family="{$defaultContentFont}" font-size="{$defaultContentSize}" text-align="justify" margin-left="2mm" space-after="1mm">
		<xsl:apply-templates select="$content"/>
	</fo:block>
	
</xsl:template>

<xsl:template name="textBlock">
		<xsl:param name="content"/>
		
		<fo:block space-after="1mm" font-family="{$defaultContentFont}" font-size="{$defaultContentSize}" text-align="justify">
			<xsl:apply-templates select="$content"/>
		</fo:block>
</xsl:template>

<xsl:template name="indexBlock">
	<xsl:param name="content"/>
	<xsl:param name="ref-id"/>
	
	<fo:block text-align-last="justify" line-height="150%">
		<fo:basic-link internal-destination="{$ref-id}">
			<xsl:value-of select="$content"/>
			<fo:leader/>
			<fo:page-number-citation ref-id="{$ref-id}"/>
		</fo:basic-link>
	</fo:block>
</xsl:template>

<xsl:template name="indexHeaderBlock">
	<xsl:param name="content"/>
	
	<fo:block font-weight="bold" space-after="2mm" space-before="5mm" padding-left="1mm" padding-top="1mm" background-color="lightgray">
		<xsl:value-of select="$content"/>
	</fo:block>
</xsl:template>

<xsl:template name="cardHeaderBlock">
	<xsl:param name="content"/>
	<xsl:param name="value"/>
	<xsl:param name="ref-id"/>
	
	<fo:block font-weight="bold" space-after="2mm" space-before="5mm" padding-left="1mm" padding-right="1mm" padding-top="1mm" background-color="lightgray" text-align-last="justify" keep-with-next="always" id="{$ref-id}">
		<xsl:value-of select="$content"/>
		<fo:leader/>
		<xsl:value-of select="$value"/>
	</fo:block>
</xsl:template>

<!--Global Layout -->
<xsl:template match="/book">
	<fo:root>
		<!-- Layout Definitions -->
		<fo:layout-master-set>
			<!-- Pages -->
			<fo:simple-page-master master-name="Page_Front_Title" page-height="297mm" page-width="210mm" margin="0mm">
				<fo:region-body margin="0mm" />
			</fo:simple-page-master>
			
			<fo:simple-page-master master-name="Page_Front_Content" page-height="297mm" page-width="210mm" margin="0mm">
				<fo:region-body margin="10mm" />
			</fo:simple-page-master>
			
			<fo:simple-page-master master-name="Page_Front_TOC" page-height="297mm" page-width="210mm" margin="0mm">
				<fo:region-body margin="10mm" column-count="2"/>
			</fo:simple-page-master>
			
			<fo:simple-page-master master-name="Page_Section_Header" page-height="297mm" page-width="210mm" margin="0mm">
				<fo:region-body margin="0mm" />
			</fo:simple-page-master>
			
			<fo:simple-page-master master-name="Page_Content" page-height="297mm" page-width="210mm" margin="0mm">
				<fo:region-body margin="10mm" margin-bottom="15mm" column-count="2" />
				<fo:region-after extent="10mm" background-color="black" />
			</fo:simple-page-master>
			
			<fo:simple-page-master master-name="Page_Content_Full" page-height="297mm" page-width="210mm" margin="0mm">
				<fo:region-body margin="0mm" />
			</fo:simple-page-master>
			
			<!-- Page Sequences -->
			<fo:page-sequence-master master-name="Seq_Frontpages">
				<fo:single-page-master-reference master-reference="Page_Front_Title" />
				<fo:repeatable-page-master-reference master-reference="Page_Front_Content" />
			</fo:page-sequence-master>
			
			<fo:page-sequence-master master-name="Seq_Sections">
				<fo:single-page-master-reference master-reference="Page_Section_Header" />
				<fo:repeatable-page-master-reference master-reference="Page_Content" />
			</fo:page-sequence-master>
			
			<fo:page-sequence-master master-name="Seq_Sections_Full">
				<fo:single-page-master-reference master-reference="Page_Section_Header" />
				<fo:repeatable-page-master-reference master-reference="Page_Content_Full" />
			</fo:page-sequence-master>
			
		</fo:layout-master-set>
		
		<!-- Bookmarks -->
		<fo:bookmark-tree>
			<xsl:apply-templates mode="bookmark"/>
			<fo:bookmark internal-destination="bookIndexes">
				<fo:bookmark-title>Indexes</fo:bookmark-title>
			</fo:bookmark>
		</fo:bookmark-tree>
		
		<!-- Main Flow Rendering -->
		<xsl:apply-templates select="/book/data" />
		
		<fo:page-sequence master-reference="Page_Front_TOC">
			<fo:flow flow-name="xsl-region-body">
				<fo:wrapper font-family="{$defaultContentFont}" font-size="{$defaultContentSize}" line-height="150%">
					<fo:block span="all" font-size="160%" margin-bottom="5mm" font-weight="bold">
						Content
					</fo:block>
					<xsl:apply-templates mode="toc"/>
					<fo:block font-family="{$defaultHeaderFont}" text-align-last="justify" space-before="3mm">
						<fo:basic-link internal-destination="bookIndexes">
							Indexes
							<fo:leader/>
							<fo:page-number-citation ref-id="bookIndexes"/>
						</fo:basic-link>
					</fo:block>
				</fo:wrapper>
			</fo:flow>
		</fo:page-sequence>
		
		<xsl:apply-templates select="/book/section"/>
		
		<!-- Indexes -->
		<fo:page-sequence master-reference="Page_Front_TOC">
			<fo:flow flow-name="xsl-region-body">
				<fo:wrapper font-family="{$defaultContentFont}" font-size="{$defaultContentSize}">
					<fo:block id="bookIndexes" span="all" font-size="160%" margin-bottom="5mm" font-weight="bold">
						Indexes
					</fo:block>
				<xsl:for-each select="//external">
					<xsl:sort select="@id"/>
					<xsl:apply-templates select="document(concat($contentBase,@file))" mode="index"/>
				</xsl:for-each>
				</fo:wrapper>
			</fo:flow>
		</fo:page-sequence>
	</fo:root>	
</xsl:template>

<!-- Front Page -->
<xsl:template match="/book/data">
	<fo:page-sequence master-reference="Seq_Frontpages">
		<fo:flow flow-name="xsl-region-body">
			<fo:block id="{generate-id(.)}" font-family="{$defaultHeaderFont}" font-size="20mm" padding-top="100mm" margin-right="20mm" text-align="right">
				<xsl:value-of select="title"/>
			</fo:block>
			<fo:block font-family="{$defaultHeaderFont}" font-size="5mm" margin-top="0mm" margin-right="20mm" text-align="right" font-variant="small-caps" break-after="page">
				<xsl:value-of select="subtitle"/>
			</fo:block>
			<fo:wrapper font-family="{$defaultContentFont}" font-size="{$defaultContentSize}" text-align="justify">
				<fo:block font-weight="bold">
					Author
				</fo:block>
				<fo:block>
					<xsl:value-of select="author"/>
				</fo:block>
				<fo:block space-before="5mm" font-weight="bold">
					Contributors
				</fo:block>
				<fo:block>
					<xsl:value-of select="sort(contributors/contributor)" separator=", "/>
				</fo:block>
				<fo:block space-before="5mm" font-weight="bold">
					Version
				</fo:block>
				<fo:block>
					<xsl:value-of select="version"/>
				</fo:block>
				<fo:block space-before="5mm" font-weight="bold">
					Publication
				</fo:block>
				<fo:block>
					<xsl:value-of select="publication"/>
				</fo:block>
				<fo:block space-before="5mm" font-weight="bold">
					Licence
				</fo:block>
				<fo:block>
					<xsl:value-of select="licence"/>
				</fo:block>
			</fo:wrapper>
		</fo:flow>
	</fo:page-sequence>
</xsl:template>

<xsl:template match="/book/data" mode="bookmark">
    <fo:bookmark internal-destination="{generate-id(.)}">
        <fo:bookmark-title><xsl:value-of select="title"/> - <xsl:value-of select="subtitle"/></fo:bookmark-title>
    </fo:bookmark>
</xsl:template>

<!-- Sections -->
<xsl:template match="/book/section">
	<xsl:variable name="pageSequence">
		<xsl:choose>
			<xsl:when test="@type='fullpage'">Seq_Sections_Full</xsl:when>
			<xsl:otherwise>Seq_Sections</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<fo:page-sequence master-reference="{$pageSequence}">
		<fo:static-content flow-name="xsl-region-after">
			<fo:block text-align="center" color="white" font-family="{$defaultHeaderFont}" line-height="10mm"><fo:page-number /></fo:block>
		</fo:static-content>
		<fo:flow flow-name="xsl-region-body">
			<fo:block id="{generate-id(.)}" font-family="{$defaultHeaderFont}" font-size="10mm" break-after="page" padding-top="120mm" text-align="right" margin-right="20mm" margin-left="20mm" border-bottom-width="0.1mm" border-bottom-color="black" border-bottom-style="solid">
				<xsl:value-of select="@title"/>
			</fo:block>
			<fo:wrapper font-size="{$defaultContentSize}" font-family="{$defaultContentFont}">
				<xsl:apply-templates/>
			</fo:wrapper>
		</fo:flow>
	</fo:page-sequence>
</xsl:template>

<xsl:template match="/book/section" mode="bookmark">
    <fo:bookmark internal-destination="{generate-id(.)}">
        <fo:bookmark-title><xsl:value-of select="@title"/></fo:bookmark-title>
		<xsl:apply-templates mode="bookmark"/>
    </fo:bookmark>
</xsl:template>

<xsl:template match="/book/section" mode="toc">
    <fo:block font-family="{$defaultHeaderFont}" text-align-last="justify" space-before="3mm" keep-with-next="always">
		<fo:basic-link internal-destination="{generate-id(.)}">
			<xsl:value-of select="@title"/>
			<fo:leader />
			<fo:page-number-citation ref-id="{generate-id(.)}"/>
		</fo:basic-link>
    </fo:block>
	<xsl:apply-templates mode="toc"/>
</xsl:template>

<!-- Chapters -->
<xsl:template match="/book/section/chapter">
	<xsl:variable name="breakColumn">
		<xsl:choose>
			<xsl:when test="position() = 1">auto</xsl:when>
			<xsl:otherwise>column</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<fo:block id="{generate-id(.)}" font-family="{$defaultHeaderFont}" font-size="160%" padding-left="1mm" padding-top="0.5mm" color="white" background-color="black" space-after="5mm" break-before="{$breakColumn}">
		<xsl:value-of select="@title" />
	</fo:block>
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="/book/section/chapter" mode="bookmark">
    <fo:bookmark internal-destination="{generate-id(.)}">
        <fo:bookmark-title>
			<xsl:value-of select="@title"/>
		</fo:bookmark-title>
		<xsl:for-each select="text[@title and not(@level)]">
			<fo:bookmark internal-destination="{generate-id(.)}">
				<fo:bookmark-title>
					<xsl:value-of select="@title"/>
				</fo:bookmark-title>
			</fo:bookmark>
		</xsl:for-each>
    </fo:bookmark>
</xsl:template>

<xsl:template match="/book/section/chapter" mode="toc">
    <fo:block font-family="{$defaultContentFont}" text-align-last="justify">
		<fo:basic-link internal-destination="{generate-id(.)}">
			<xsl:value-of select="@title"/>
			<fo:leader />
			<fo:page-number-citation ref-id="{generate-id(.)}"/>
		</fo:basic-link>
    </fo:block>
	<xsl:apply-templates mode="toc"/>
</xsl:template>

<!-- Text -->
<xsl:template match="/book/section/chapter/text">
	<xsl:if test="@title">
		<xsl:call-template name="headerBlock">
			<xsl:with-param name="content" select="@title"/>
			<xsl:with-param name="level" select="@level"/>
			<xsl:with-param name="value" select="@value"/>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="text()">
		<xsl:call-template name="textBlock">
			<xsl:with-param name="content" select="node()"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<xsl:template match="/book/section/chapter/text" mode="toc">
	<xsl:if test="@title and (not(@level) or (@level &lt; 3))">
		<xsl:variable name="textIndent">
			<xsl:choose>
				<xsl:when test="@level = 2">6mm</xsl:when>
				<xsl:otherwise>3mm</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block margin-left="{$textIndent}" text-align-last="justify">
			<fo:basic-link internal-destination="{generate-id(.)}">
				<xsl:value-of select="@title"/>
				<fo:leader />
				<fo:page-number-citation ref-id="{generate-id(.)}"/>
			</fo:basic-link>
		</fo:block>
	</xsl:if>
</xsl:template>

<!-- Definitions -->
<xsl:template match="/book/section//definitions">
	<xsl:apply-templates select="definition"/>
</xsl:template>

<xsl:template match="/book/section//definition">
	<xsl:call-template name="definitionBlock">
		<xsl:with-param name="title" select="@title"/>
		<xsl:with-param name="abbreviation" select="@abbreviation"/>
		<xsl:with-param name="content" select="node()"/>
	</xsl:call-template>
</xsl:template>

<!-- Tables -->
<xsl:template match="/book/section//table">
	<fo:table space-before="5mm" space-after="5mm" margin-left="5mm" margin-right="5mm" keep-together.within-column="always">
		<fo:table-body>
			<xsl:apply-templates select="line"/>
		</fo:table-body>
	</fo:table>
</xsl:template>

<xsl:template match="/book/section//table/line">
	<fo:table-row>
		<xsl:apply-templates select="cell"/>
	</fo:table-row>
</xsl:template>

<xsl:template match="/book/section//table/line/cell">
	<fo:table-cell>
		<xsl:variable name="fontWeight">
			<xsl:choose>
				<xsl:when test="@type='header'">bold</xsl:when>
				<xsl:otherwise>regular</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block font-weight="{$fontWeight}">
			<xsl:value-of select="." />
		</fo:block>
	</fo:table-cell>
</xsl:template>

<!-- Pictures -->
<xsl:template match="picture">
	<xsl:choose>
		<xsl:when test="@display='page'">
			<fo:block span="all">
				<fo:external-graphic src="{$pictureBase}/{@source}.png"/>
			</fo:block>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<!-- References -->
<xsl:template match="reference">
	<fo:inline font-style="italic">
		<fo:basic-link internal-destination="{generate-id(key('titles',@ref))}">
			<xsl:apply-templates select="node()"/>
		</fo:basic-link>
	</fo:inline>
</xsl:template>

<!-- External Imports -->
<xsl:template match="external">
    <xsl:apply-templates select="document(concat($contentBase,@file))" />
</xsl:template>

<!-- Conditions -->
<xsl:template match="conditions">
	<xsl:apply-templates><xsl:sort select="@name" /></xsl:apply-templates>
</xsl:template>

<xsl:template match="conditions" mode="index">
	<xsl:call-template name="indexHeaderBlock">
		<xsl:with-param name="content">Conditions</xsl:with-param>
	</xsl:call-template>
	<xsl:for-each select="condition">
		<xsl:call-template name="indexBlock">
			<xsl:with-param name="content" select="@name"/>
			<xsl:with-param name="ref-id" select="generate-id(.)"/>
		</xsl:call-template>
	</xsl:for-each>
</xsl:template>

<xsl:template match="conditions/condition">
	<xsl:call-template name="definitionBlock">
		<xsl:with-param name="title" select="@name"/>
		<xsl:with-param name="content" select="node()"/>
		<xsl:with-param name="ref-id" select="generate-id(.)"/>
	</xsl:call-template>
</xsl:template>

<!-- Origins -->
<xsl:template match="origins">
	<xsl:apply-templates select="origin">
		<xsl:sort select="@name" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="origins" mode="index">
	<xsl:call-template name="indexHeaderBlock">
		<xsl:with-param name="content">Origins</xsl:with-param>
	</xsl:call-template>
	<xsl:for-each select="origin">
		<xsl:sort select="@name"/>
		<xsl:call-template name="indexBlock">
			<xsl:with-param name="content" select="@name"/>
			<xsl:with-param name="ref-id" select="generate-id(.)"/>
		</xsl:call-template>
	</xsl:for-each>
</xsl:template>

<xsl:template match="origins/origin">
	<xsl:call-template name="headerBlock">
		<xsl:with-param name="content" select="@name"/>
	</xsl:call-template>
	<xsl:call-template name="textBlock">
		<xsl:with-param name="content" select="description/text/text()"/>
	</xsl:call-template>
	<fo:block text-align-last="justify" space-before="3mm">
		<fo:inline font-weight="bold">Size</fo:inline>
		<fo:leader/>
		<xsl:value-of select="size"/>
		<fo:leader/>
		<fo:inline font-weight="bold">Base Speed</fo:inline>
		<fo:leader/>
		<xsl:value-of select="speed"/>
	</fo:block>
	<xsl:call-template name="definitionBlock">
		<xsl:with-param name="title">Origin Skills</xsl:with-param>
		<xsl:with-param name="content">
			<xsl:value-of select="sort(skills/skill/@name)" separator=", "/>
		</xsl:with-param>
	</xsl:call-template>
	<xsl:call-template name="definitionBlock">
		<xsl:with-param name="title">Origin Abilities</xsl:with-param>
		<xsl:with-param name="content">
			<xsl:value-of select="sort(abilities/common/ability/@name)" separator=", "/>
		</xsl:with-param>
	</xsl:call-template>
	<xsl:if test="abilities/unique/ability">
		<xsl:call-template name="definitionBlock">
			<xsl:with-param name="title">Unique Abilities</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:value-of select="sort(abilities/unique/ability/@name)" separator=", "/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates select="abilities/unique/ability" />
	</xsl:if>
</xsl:template>

<!-- Abilities -->
<xsl:template match="abilities">
	<xsl:apply-templates select="category">
		<xsl:sort select="@name"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="abilities" mode="index">
	<xsl:call-template name="indexHeaderBlock">
		<xsl:with-param name="content">Abilities</xsl:with-param>
	</xsl:call-template>
	<xsl:for-each select="//ability">
		<xsl:sort select="@name"/>
		<xsl:call-template name="indexBlock">
			<xsl:with-param name="content" select="@name"/>
			<xsl:with-param name="ref-id" select="generate-id(.)"/>
		</xsl:call-template>
	</xsl:for-each>
</xsl:template>

<xsl:template match="abilities/category">
	<xsl:call-template name="headerBlock">
		<xsl:with-param name="content" select="@name"/>
	</xsl:call-template>
	<xsl:call-template name="textBlock">
		<xsl:with-param name="content" select="description/text()"/>
	</xsl:call-template>
	<xsl:apply-templates select="ability">
		<xsl:sort select="@name" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="abilities//ability">
	<xsl:call-template name="cardHeaderBlock">
		<xsl:with-param name="content" select="@name"/>
		<xsl:with-param name="value" select="@cost"/>
		<xsl:with-param name="ref-id" select="generate-id(.)"/>
	</xsl:call-template>
	<fo:table space-after="2mm" keep-together="always">
		<fo:table-body>
			<fo:table-row>
				<fo:table-cell><fo:block font-weight="bold">Multiple</fo:block></fo:table-cell>
				<fo:table-cell><fo:block><xsl:value-of select="@multiple"/></fo:block></fo:table-cell>
			</fo:table-row>
			<fo:table-row>
				<fo:table-cell><fo:block font-weight="bold">Pre-requisite</fo:block></fo:table-cell>
				<fo:table-cell><fo:block><xsl:value-of select="@prerequisite"/></fo:block></fo:table-cell>
			</fo:table-row>
			<fo:table-row>
				<fo:table-cell><fo:block font-weight="bold">Incompatibility</fo:block></fo:table-cell>
				<fo:table-cell><fo:block><xsl:value-of select="@incompatibility"/></fo:block></fo:table-cell>
			</fo:table-row>
		</fo:table-body>
	</fo:table>
	<xsl:call-template name="textBlock">
		<xsl:with-param name="content" select="node()"/>
	</xsl:call-template>
</xsl:template>

<!-- Occupations -->
<xsl:template match="occupations">
	<xsl:apply-templates select="category">
		<xsl:sort select="@name"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="occupations" mode="index">
	<xsl:call-template name="indexHeaderBlock">
		<xsl:with-param name="content">Occupations</xsl:with-param>
	</xsl:call-template>
	<xsl:for-each select="//occupation">
		<xsl:sort select="@name"/>
		<xsl:call-template name="indexBlock">
			<xsl:with-param name="content" select="@name"/>
			<xsl:with-param name="ref-id" select="generate-id(.)"/>
		</xsl:call-template>
	</xsl:for-each>
</xsl:template>

<xsl:template match="occupations/category">
	<xsl:call-template name="headerBlock">
		<xsl:with-param name="content" select="@name"/>
	</xsl:call-template>
	<xsl:call-template name="textBlock">
		<xsl:with-param name="content" select="description/text()"/>
	</xsl:call-template>
	<xsl:apply-templates select="occupation">
		<xsl:sort select="@name" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="occupations//occupation">
	<xsl:call-template name="cardHeaderBlock">
		<xsl:with-param name="content" select="@name"/>
		<xsl:with-param name="value" select="@cost"/>
		<xsl:with-param name="ref-id" select="generate-id(.)"/>
	</xsl:call-template>
	<fo:table space-after="2mm" keep-together="always">
		<fo:table-body>
			<fo:table-row>
				<fo:table-cell><fo:block font-weight="bold">TBD</fo:block></fo:table-cell>
				<fo:table-cell><fo:block><xsl:value-of select="@multiple"/></fo:block></fo:table-cell>
			</fo:table-row>
			<fo:table-row>
				<fo:table-cell><fo:block font-weight="bold">TBD</fo:block></fo:table-cell>
				<fo:table-cell><fo:block><xsl:value-of select="@prerequisite"/></fo:block></fo:table-cell>
			</fo:table-row>
			<fo:table-row>
				<fo:table-cell><fo:block font-weight="bold">TBD</fo:block></fo:table-cell>
				<fo:table-cell><fo:block><xsl:value-of select="@incompatibility"/></fo:block></fo:table-cell>
			</fo:table-row>
		</fo:table-body>
	</fo:table>
	<xsl:call-template name="definitionBlock">
		<xsl:with-param name="title">Occupation Skills</xsl:with-param>
		<xsl:with-param name="content">
			<xsl:value-of select="sort(skills/skill/@name)" separator=", "/>
		</xsl:with-param>
	</xsl:call-template>
	<xsl:call-template name="definitionBlock">
		<xsl:with-param name="title">Occupation Abilities</xsl:with-param>
		<xsl:with-param name="content">
			<xsl:value-of select="sort(abilities/common/ability/@name)" separator=", "/>
		</xsl:with-param>
	</xsl:call-template>
	<xsl:if test="abilities/unique/ability">
		<xsl:call-template name="definitionBlock">
			<xsl:with-param name="title">Unique Abilities</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:value-of select="sort(abilities/unique/ability/@name)" separator=", "/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates select="abilities/unique/ability" />
	</xsl:if>
	<xsl:call-template name="textBlock">
		<xsl:with-param name="content" select="node()"/>
	</xsl:call-template>
</xsl:template>

<!-- Skills -->
<xsl:template match="skills">
	<xsl:apply-templates select="category">
		<xsl:sort select="@name"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="skills" mode="index">
	<xsl:call-template name="indexHeaderBlock">
		<xsl:with-param name="content">Skills</xsl:with-param>
	</xsl:call-template>
	<xsl:for-each select="//skill">
		<xsl:sort select="@name"/>
		<xsl:call-template name="indexBlock">
			<xsl:with-param name="content" select="@name"/>
			<xsl:with-param name="ref-id" select="generate-id(.)"/>
		</xsl:call-template>
	</xsl:for-each>
</xsl:template>

<xsl:template match="skills/category">
	<xsl:call-template name="headerBlock">
		<xsl:with-param name="content" select="@name"/>
	</xsl:call-template>
	<xsl:if test="description">
		<xsl:call-template name="textBlock">
			<xsl:with-param name="content" select="description/text()"/>
		</xsl:call-template>
	</xsl:if>
	<xsl:apply-templates select="skill">
		<xsl:sort select="@name" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="skills//skill">
	<xsl:call-template name="cardHeaderBlock">
		<xsl:with-param name="content" select="@name"/>
		<xsl:with-param name="value" select="@trait"/>
		<xsl:with-param name="ref-id" select="generate-id(.)"/>
	</xsl:call-template>
	<xsl:call-template name="textBlock">
		<xsl:with-param name="content" select="node()"/>
	</xsl:call-template>
</xsl:template>


<!-- Defaults -->
<xsl:template match="text">
	<xsl:value-of select="text()"/>
</xsl:template>
<xsl:template match="*" />
<xsl:template match="*" mode="bookmark" />
<xsl:template match="*" mode="toc" />
<xsl:template match="*" mode="index" />

</xsl:stylesheet>