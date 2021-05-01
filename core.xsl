<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" />
<xsl:key name="titles" match="*" use="@ref-id"/>
<!-- **************************************************** -->
<xsl:variable name="contentBase">./content/</xsl:variable>
<!-- **************************************************** -->
<xsl:template match="external">
    <xsl:apply-templates select="document(concat($contentBase,@file))" />
</xsl:template>
<!-- **************************************************** -->
<xsl:template match="/book">
    <html>
        <head>
            <title><xsl:value-of select="data/title"/> - <xsl:value-of select="data/subtitle"/></title>
            <script src="core.js" />
            <link rel="stylesheet" href="style.css" />
            <link rel="stylesheet" href="print.css" />
        </head>
        <body>
            <xsl:apply-templates select="data"/>
            <nav>
                <div class="page">
                    <h1 id="toc">Content</h1>
                    <xsl:apply-templates select="section" mode="toc"/>
                    <a href="#indexes" data-level="1">Indexes</a>
                </div>
            </nav>
            <xsl:apply-templates select="section"/>
            <footer>
                <nav>
                    <div class="page">
                        <h1 id="indexes">Indexes</h1>
                        <h2>Conditions</h2>
                        <xsl:apply-templates select="document(concat($contentBase,//external[@id='conditions']/@file))//conditions" mode="index">
                            <xsl:sort select="@name" />
                        </xsl:apply-templates>
                        <h2>Origins</h2>
                        <xsl:apply-templates select="document(concat($contentBase,//external[@id='origins']/@file))//origin" mode="index">
                            <xsl:sort select="@name" />
                        </xsl:apply-templates>
                        <h2>Occupations</h2>
                        <xsl:apply-templates select="document(concat($contentBase,//external[@id='occupations']/@file))//occupation" mode="index">
                            <xsl:sort select="@name" />
                        </xsl:apply-templates>
                        <h2>Skills</h2>
                        <xsl:apply-templates select="document(concat($contentBase,//external[@id='skills']/@file))//skill" mode="index">
                            <xsl:sort select="@name" />
                        </xsl:apply-templates>
                        <h2>Abilities</h2>
                        <xsl:apply-templates select="document(concat($contentBase,//external[@id='abilities']/@file))//ability" mode="index">
                            <xsl:sort select="@name" />
                        </xsl:apply-templates>
                    </div>
                </nav>
            </footer>
        </body>
    </html>
</xsl:template>

<xsl:template match="data">
    <header>
        <div class="page">
            <h1><xsl:value-of select="title"/></h1>
            <h2><xsl:value-of select="subtitle"/></h2>
        </div>
        <div class="page">
            <article>
                <h5>Author</h5><p><xsl:value-of select="author"/></p>
                <h5>Contributors</h5><p><xsl:apply-templates select="contributors/contributor"><xsl:sort select="." /></xsl:apply-templates></p>
            </article>
            <article>
                <h5>Version</h5><p><xsl:value-of select="version"/></p>
                <h5>Publication</h5><p><xsl:value-of select="publication"/></p>
            </article>
            <article>
                <h5>Licence</h5><p><xsl:value-of select="licence"/></p>
            </article>
        </div>
    </header>
</xsl:template>
<!-- **************************************************** -->
<xsl:template match="contributor">
    <xsl:value-of select="."/>
    <xsl:if test="not(position() = last())">
        <xsl:text>, </xsl:text> 
    </xsl:if>
</xsl:template>
<!-- **************************************************** -->
<xsl:template match="reference">
    <cite>
        <xsl:element name="a">
            <xsl:attribute name="href">
                #<xsl:value-of select="generate-id(key('titles',@ref))"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </cite>
</xsl:template>
<!-- **************************************************** -->
<xsl:template match="table">
    <table><xsl:apply-templates select="line"/></table>
</xsl:template>
<xsl:template match="table/line">
    <tr><xsl:apply-templates select="cell"/></tr>
</xsl:template>
<xsl:template match="table/line/cell">
    <xsl:choose>
        <xsl:when test="@type = 'header'">
            <th><xsl:value-of select="."/></th>
        </xsl:when>
        <xsl:otherwise>
            <td class=""><xsl:value-of select="."/></td>
        </xsl:otherwise>
    </xsl:choose>    
</xsl:template>

<xsl:template match="list">
    <xsl:if test="@title">
        <h5><xsl:value-of select="@title" /></h5>
    </xsl:if>
    <ul>
        <xsl:choose>
            <xsl:when test="@sorted = 'yes'">
                <xsl:apply-templates select="item"><xsl:sort select="." /></xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="item"/>
            </xsl:otherwise>
        </xsl:choose>
    </ul>
</xsl:template>
<xsl:template match="list/item">
    <li><xsl:value-of select="."/></li>
</xsl:template>
<!-- **************************************************** -->
<xsl:template match="page-break">
    <br />
</xsl:template>
<!-- **************************************************** -->
<xsl:template match="section|chapter" mode="toc">
    <xsl:variable name="level">
        <xsl:choose>
            <xsl:when test="name() = 'section'">1</xsl:when>
            <xsl:when test="name() = 'chapter'">2</xsl:when>
        </xsl:choose>
    </xsl:variable>
    <a href="#{generate-id(.)}" data-level="{$level}"><xsl:value-of select="@title"/></a>
    <xsl:apply-templates mode="toc"/>
</xsl:template>

<xsl:template match="text" mode="toc">
    <xsl:if test="@title">
        <xsl:variable name="level">
            <xsl:choose>
                <xsl:when test="@level"><xsl:value-of select="@level+2"/></xsl:when>
                <xsl:otherwise>3</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <a href="#{generate-id(.)}" data-level="{$level}"><xsl:value-of select="@title"/></a>
    </xsl:if>
</xsl:template>

<xsl:template match="*" mode="toc">
</xsl:template>
<!-- **************************************************** -->
<xsl:template match="conditions | origins | skills | abilities | occupations" mode="index">
    <xsl:apply-templates mode="index"><xsl:sort select="@name" /></xsl:apply-templates>
</xsl:template>
<xsl:template match="*[@name]" mode="index">
    <a href="#{generate-id(.)}" data-level="2"><xsl:value-of select="@name" /></a>
</xsl:template>
<!-- **************************************************** -->
<xsl:template match="section">
    <section id="{generate-id(.)}">
        <div class="page">
            <h1><xsl:value-of select="@title"/></h1>
        </div>
        <div class="page">
            <xsl:apply-templates/>
        </div>
    </section>
</xsl:template>

<xsl:template match="chapter">
    <h2 id="{generate-id(.)}"><xsl:value-of select="@title"/></h2>
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="text">
    <article>
    <xsl:if test="@title">
        <xsl:variable name="level">
            <xsl:choose>
                <xsl:when test="@level"><xsl:value-of select="@level+2"/></xsl:when>
                <xsl:otherwise>3</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{concat('h', $level)}" >
            <xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
            <xsl:if test="@value">
                <xsl:attribute name="data-value"><xsl:value-of select="@value"/></xsl:attribute>
            </xsl:if>
            <xsl:value-of select="@title"/>
        </xsl:element>
    </xsl:if>
    <xsl:if test="text()">
        <p><xsl:apply-templates/></p>
    </xsl:if>
    </article>
</xsl:template>

<xsl:template match="definitions">
        <xsl:apply-templates select="definition"/>
</xsl:template>

<xsl:template match="definitions/definition">
    <article>
    <xsl:element name="h5">
        <xsl:if test="@abbreviation">
            <xsl:attribute name="data-abbr">
                <xsl:value-of select="@abbreviation"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:value-of select="@title"/>
    </xsl:element>
    <p><xsl:apply-templates/></p>
    </article>
</xsl:template>
<!-- **************************************************** -->
<xsl:template match="conditions">
    <xsl:apply-templates><xsl:sort select="@name" /></xsl:apply-templates>
</xsl:template>
<xsl:template match="conditions/condition">
    <article>
        <h4 id="{generate-id(.)}"><xsl:value-of select="@name" /></h4>
        <p><xsl:value-of select="text()" /></p>
    </article>
</xsl:template>
<!-- **************************************************** -->
<xsl:template match="origins">
    <xsl:apply-templates><xsl:sort select="@name" /></xsl:apply-templates>
</xsl:template>
<!-- **************************************************** -->
<xsl:template match="origin">
    <article class="origin">
        <h3 id="{generate-id(.)}"><xsl:value-of select="@name"/></h3>
        <xsl:apply-templates select="description" />
            <div>
                <span class="label">Size</span><span><xsl:value-of select="size"/></span>
                <span class="label">Base Speed</span><span><xsl:value-of select="speed"/></span>
            </div>
        <article>
            <h5>Origin Skills</h5>
            <p><xsl:apply-templates select="skills/skill" mode="list"><xsl:sort select="@name" /></xsl:apply-templates></p>
            <h5>Origin Abilities</h5>
            <p><xsl:apply-templates select="abilities/common/ability" mode="list"><xsl:sort select="@name" /></xsl:apply-templates></p>
            <xsl:if test="abilities/unique/ability">
                <h5>Unique Abilities</h5>
                <p><xsl:apply-templates select="abilities/unique/ability" mode="list"><xsl:sort select="@name" /></xsl:apply-templates></p>
            </xsl:if>
        </article>
        <xsl:if test="abilities/unique/ability">
            <xsl:apply-templates select="abilities/unique/ability"><xsl:sort select="@name" /></xsl:apply-templates>
        </xsl:if>
    </article>
</xsl:template>
<!-- **************************************************** -->
<xsl:template match="occupations | abilities | skills">
    <xsl:apply-templates select="./category | ./page-break"><xsl:sort select="@name" /></xsl:apply-templates>
</xsl:template>

<xsl:template match="occupations/category | abilities/category | skills/category">
    <h3><xsl:value-of select="@name" /></h3>
    <p><xsl:value-of select="./description" /></p>
    <xsl:apply-templates select="./occupation | ./ability | ./skill | ./page-break"><xsl:sort select="@name" /></xsl:apply-templates>
</xsl:template>

<xsl:template match="occupation | ability | skill" mode="list">
    <xsl:value-of select="@name"/>
    <xsl:if test="not(position() = last())">
        <xsl:text>, </xsl:text> 
    </xsl:if>
</xsl:template>
<!-- **************************************************** -->
<xsl:template match="occupations/category/occupation">
    <article class="occupation">
        <h4 id="{generate-id(.)}"><xsl:value-of select="@name"/></h4>
        <table>
            <tr>
                <th>Occupation Traits</th><td colspan="3"><xsl:value-of select="traits"/></td>
            </tr>
            <tr>
                <th>Physical Health</th><td><xsl:value-of select="health/physical"/></td>
                <th>Mental Health</th><td><xsl:value-of select="health/mental"/></td>
            </tr>
            <tr>
                <th>Physical Defense</th><td><xsl:value-of select="defenses/physical"/></td>
                <th>Mental Defense</th><td><xsl:value-of select="defenses/mental"/></td>
            </tr>
            <tr>
                <th>Other Defenses</th><td colspan="3"><xsl:value-of select="defenses/other"/></td>
            </tr>
        </table>
        <article>
            <h5>Occupation Skills</h5>
            <p><xsl:apply-templates select="skills/skill"><xsl:sort select="." /></xsl:apply-templates></p>
            <h5>Occupation Abilities</h5>
            <p><xsl:apply-templates select="abilities/common/ability" mode="list"><xsl:sort select="@name" /></xsl:apply-templates></p>
            <xsl:if test="abilities/unique/ability">
                <h5>Unique Abilities</h5>
                <p><xsl:apply-templates select="abilities/unique/ability" mode="list"><xsl:sort select="@name" /></xsl:apply-templates></p>
            </xsl:if>
        </article>
        <xsl:apply-templates select="description" />
        <xsl:if test="abilities/unique/ability">
            <xsl:apply-templates select="abilities/unique/ability"><xsl:sort select="@name" /></xsl:apply-templates>
        </xsl:if>
    </article>
</xsl:template>
<!-- **************************************************** -->
<xsl:template match="ability">
    <article class="ability">
        <h4 id="{generate-id(.)}" data-value="{@cost}"><xsl:value-of select="@name"/></h4>
        <table>
            <tr><th>Multiple</th><td><xsl:value-of select="@multiple"/></td></tr>
            <tr><th>Pre-requisite</th><td><xsl:value-of select="@prerequisite"/></td></tr>
            <tr><th>Incompatibility</th><td><xsl:value-of select="@incompatibility"/></td></tr>
        </table>
    <xsl:apply-templates/>
    </article>
</xsl:template>
<!-- **************************************************** -->
<xsl:template match="skills/category/skill">
    <article class="skill">
        <h4 id="{generate-id(.)}" data-value="{@trait}"><xsl:value-of select="@name" /></h4>
        <xsl:apply-templates />
    </article>
</xsl:template>
<!-- **************************************************** -->
<xsl:template match="picture">
    <xsl:element name="img">
        <xsl:attribute name="src"><xsl:value-of select="concat('./pictures/',@source,'.png')" /></xsl:attribute>
        <xsl:if test="@display">
            <xsl:attribute name="class"><xsl:value-of select="@display" /></xsl:attribute>
        </xsl:if>
    </xsl:element>
</xsl:template>

</xsl:stylesheet>
