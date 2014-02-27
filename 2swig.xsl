<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:b='http://www.google.com/2005/gml/b'
	xmlns:data='http://www.google.com/2005/gml/data'
	xmlns:expr='http://www.google.com/2005/gml/expr'
	xmlns:xhtml='http://www.w3.org/1999/xhtml'
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="b data expr"
	>


	<xsl:output
		method="xml"
		indent="yes"
		encoding="UTF-8"
		omit-xml-declaration="yes"
		standalone="yes"
		/>

	<xsl:variable name="quote">'</xsl:variable>
	<xsl:variable name="widgets" select="concat('Blog', '|', 'PageListX', '|', 'Label', '|')"/>
	<xsl:variable name="includables" select="concat('main', '|')"/>

	<xsl:template match="b:if">
		<xsl:variable name="uid" select="generate-id()" />
		<xsl:value-of select="concat('{# ','(',  $uid, ' #}')"/>
		<xsl:value-of select="concat('{% if ', translate(@cond, ':', '.'), ' %}')"/>
		<xsl:apply-templates/>
		<xsl:value-of select="concat('{% ', 'endif', ' %}')"/>
		<xsl:value-of select="concat('{# ',  $uid, ')', ' #}')"/>
	</xsl:template>

	<xsl:template match="b:else">
		<xsl:value-of select="concat('{% ', 'else', ' %}')"/>
	</xsl:template>


	<xsl:template match="b:loop">
		<xsl:variable name="uid" select="generate-id()" />
		<xsl:value-of select="concat('{# ','(',  $uid, ' #}')"/>
		<xsl:value-of select="concat('{% for ',@var,' in ', translate(@values, ':', '.'), ' %}')"/>
		<xsl:apply-templates/>
		<xsl:value-of select="concat('{% ', 'endfor', ' %}')"/>
		<xsl:value-of select="concat('{# ',  $uid, ')', ' #}')"/>
	</xsl:template>

	<xsl:template match="b:includable">
		<xsl:choose>
			<xsl:when test="contains($includables, concat(@id, '|'))">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment>Ignored</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="b:include">
		<!-- <xsl:value-of select="concat('{{ ', translate(@name, '-', '_'), '(', translate(@data, ':', '.'), ') }}')"/> -->
	</xsl:template>

	<xsl:template match="xhtml:iframe">
	</xsl:template>

	<xsl:template match="xhtml:html">
		<xsl:element name="html">
			<xsl:apply-templates select="*"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="b:skin">
		<xsl:element name="style">
			<xsl:attribute name="type">
				<xsl:value-of select="concat('text', '/css')"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="b:template-skin">
		<xsl:element name="style">
			<xsl:attribute name="templated">
				<xsl:value-of select="concat('', 'yes')"/>
			</xsl:attribute>
			<xsl:attribute name="type">
				<xsl:value-of select="concat('text', '/css')"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="b:variable">
		<xsl:value-of select="concat('{% set ', @name,' = ', @value, '|default(', @default,')', ' %}')"/>
	</xsl:template>

	<xsl:template match="b:widget">
		<xsl:element name="div">
			<xsl:attribute name="id">
				<xsl:value-of select="@id"/>
			</xsl:attribute>
			<xsl:attribute name="class">
				<xsl:value-of select="@class"/>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:value-of select="@title"/>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="contains($widgets, concat(@type, '|'))">
					<xsl:apply-templates select="*"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:comment>Ignored</xsl:comment>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:comment>
				<xsl:value-of select="concat('widget : div#', @id)"/>
		</xsl:comment>
		</xsl:element>
	</xsl:template>

	<xsl:template match="b:section">
		<xsl:if test="@id != 'navbar'">
			<xsl:element name="div">
				<xsl:attribute name="id">
					<xsl:value-of select="@id"/>
				</xsl:attribute>
				<xsl:attribute name="class">
					<xsl:value-of select="@class"/>
				</xsl:attribute>
				<xsl:apply-templates  select="*"/>
				<xsl:comment>
					<xsl:value-of select="concat('section : div#', @id)"/>
				</xsl:comment>
			</xsl:element>
		</xsl:if>
	</xsl:template>


	<xsl:template match="@expr:*">
		<xsl:attribute name="{local-name()}">
			<xsl:value-of select="concat('{{ ', translate(current(), ':', '.'), ' }}')"/>
			<!-- <xsl:apply-templates select="@*"/> -->
		</xsl:attribute>
	</xsl:template>



	<xsl:template match="data:*">
		<xsl:value-of select="concat('{{ ', translate(name(), ':', '.'), '|default(',$quote,translate(name(), ':', '.'),$quote,') }}')"/>
	</xsl:template>

	<xsl:template match="@*">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
			<xsl:text> </xsl:text>
		</xsl:copy>
	</xsl:template>


</xsl:stylesheet>
