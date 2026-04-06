<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template match="/transport">

    <xsl:variable name="stations" select="stations/station"/>

    <xsl:variable name="lines" select="lines/line"/>


    <html>
        <head>
            <title>Train Trips Report</title>
            <link rel="stylesheet" type="text/css" href="style.css"/>
        </head>
        <body>
            <h1>Train Trips Report</h1>

            <xsl:for-each select="lines/line">
                <h2>
                    Line: <xsl:value-of select="@code"/> 
                    ( 
                    <xsl:value-of select="$stations[@id = current()/@departure]/@name"/>
                     - 
                    <xsl:value-of select="$stations[@id = current()/@arrival]/@name"/> 
                    )
                </h2>

                <h3>
                    Detailed List of Trips:
                </h3>

                <xsl:for-each select = "trips/trip">
                    <p>
                        Trip No. <xsl:value-of select="@code"/>: 
                        departure: <xsl:value-of select="$stations[@id = $lines/@departure]/@name"/>
                        | 
                        Arrival: <xsl:value-of select="$stations[@id = $lines/@arrival]/@name"/>
                    </p>

                    
                        <table>
                            <tr>
                                <th>schedule</th>
                                <th>Train Type</th>
                                <th>Class</th>
                                <th>Price(DA)</th>
                            </tr>

                            <xsl:for-each select = "class">
                                <tr>
                                    <td><xsl:value-of select="../schedule/@departure"/> - <xsl:value-of select="../schedule/@arrival"/></td>
                                    <td><xsl:value-of select="../@type"/></td>
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="@type='VIP'">
                                                <span class="vip-text">
                                                    <xsl:value-of select="@type"/>
                                                </span>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="@type"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        
                                    </td>
                                    <td><xsl:value-of select="@price"/></td>
                                </tr>
                            </xsl:for-each>
                        </table>
                    
                </xsl:for-each>
                
            </xsl:for-each>
        </body>
    </html>

</xsl:template>

</xsl:stylesheet>