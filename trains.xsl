<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template match="/transport">

    <html>
        <head>
            <title>Train Trips Report</title>
        </head>
        <body>
            <h1>Train Trips Report</h1>

            <xsl:for-each select="lines/line">
                <hr/>
                <hr/>
                <h2>
                    Line: <xsl:value-of select="@code"/> ( <xsl:value-of select="@departure"/> - <xsl:value-of select="@arrival"/> )
                </h2>
                <hr/>

                <h3>
                    Detailed List of Trips:
                </h3>

                <xsl:for-each select = "trips/trip">
                    <p>
                        Trip No. <xsl:value-of select="@code"/>: departure: | Arrival: 
                    </p>

                    
                        <table border="1">
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
                                    <td><xsl:value-of select="@type"/></td>
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