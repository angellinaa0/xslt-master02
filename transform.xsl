<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/2000/Transform">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- 1. Ключ для группировки уникальных городов (используем item) -->
    <xsl:key name="cities" match="item" use="@city"/>

    <!-- 2. Составной ключ для компаний внутри города -->
    <xsl:key name="companies-by-city" match="item" use="concat(@city, '|', @org)"/>

    <xsl:template match="/*">
        <html>
        <head>
            <meta charset="UTF-8"/>
            <title>Города и компании</title>
        </head>
        <body>
            <h1>Города и компании</h1>
            <ul>
                <!-- Итерация по уникальным городам -->
                <xsl:for-each select="//item[generate-id() = generate-id(key('cities', @city)[1])]">
                    <xsl:variable name="currentCity" select="@city"/>
                    <xsl:variable name="cityItems" select="//item[@city = $currentCity]"/>
                    
                    <li>
                        <strong><xsl:value-of select="$currentCity"/></strong>
                        <p>Всего товаров: <xsl:value-of select="count($cityItems)"/></p>
                        
                        <ul>
                            <!-- Итерация по уникальным компаниям города -->
                            <xsl:for-each select="$cityItems[generate-id() = generate-id(key('companies-by-city', concat($currentCity, '|', @org))[1])]">
                                <xsl:variable name="currentOrg" select="@org"/>
                                <xsl:variable name="orgItems" select="$cityItems[@org = $currentOrg]"/>
                                
                                <li>
                                    <strong><xsl:value-of select="$currentOrg"/></strong>
                                    <p>Всего товаров: <xsl:value-of select="count($orgItems)"/></p>
                                    
                                    <ul>
                                        <!-- Список товаров компании -->
                                        <xsl:for-each select="$orgItems">
                                            <li><xsl:value-of select="@title"/></li>
                                        </xsl:for-each>
                                    </ul>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </li>
                </xsl:for-each>
            </ul>
        </body>
        </html>
    </xsl:template>
</xsl:stylesheet>