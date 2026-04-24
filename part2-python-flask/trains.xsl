<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- Key to look up station names by ID -->
  <xsl:key name="station-by-id" match="station" use="@id"/>

  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Train Trips Report</title>
        <style>
          * { box-sizing: border-box; margin: 0; padding: 0; }
          body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f4f8;
            color: #2d3748;
            padding: 30px 20px;
          }
          header {
            text-align: center;
            background: linear-gradient(135deg, #1a365d, #2b6cb0);
            color: white;
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
          }
          header p.subtitle {
            font-size: 13px;
            opacity: 0.8;
            margin-top: 6px;
          }
          h1 { font-size: 2rem; letter-spacing: 1px; }
          .watermark {
            text-align: center;
            font-size: 12px;
            color: #a0aec0;
            margin-bottom: 30px;
            font-style: italic;
          }
          .line-card {
            background: white;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            overflow: hidden;
          }
          .line-header {
            background: linear-gradient(90deg, #ebf8ff, #bee3f8);
            padding: 16px 24px;
            border-bottom: 2px solid #90cdf4;
          }
          .line-header h2 {
            font-size: 1.2rem;
            color: #2c5282;
            font-weight: 700;
          }
          .line-header h2 span.arrow { color: #e53e3e; }
          .line-body { padding: 20px 24px; }
          .detail-label {
            color: #c05621;
            font-weight: 700;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 14px;
          }
          .trip-block { margin-bottom: 22px; }
          .trip-title {
            font-weight: 700;
            font-size: 0.95rem;
            margin-bottom: 10px;
            color: #2d3748;
          }
          .trip-title span { color: #e53e3e; margin: 0 6px; }
          table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
          }
          thead tr {
            background: #4a5568;
            color: white;
          }
          thead th {
            padding: 10px 14px;
            text-align: center;
            font-weight: 600;
            letter-spacing: 0.3px;
          }
          tbody tr { border-bottom: 1px solid #e2e8f0; }
          tbody tr:hover { background: #f7fafc; }
          tbody td {
            padding: 10px 14px;
            text-align: center;
            color: #4a5568;
          }
          .vip-row td { color: #6b46c1; font-weight: 600; }
          .days-tag {
            display: inline-block;
            background: #ebf8ff;
            color: #2b6cb0;
            border: 1px solid #90cdf4;
            border-radius: 20px;
            padding: 2px 10px;
            font-size: 0.78rem;
            margin-top: 6px;
          }
          footer {
            text-align: center;
            margin-top: 30px;
            font-size: 0.8rem;
            color: #a0aec0;
          }
        </style>
      </head>
      <body>
        <header>
          <h1>&#x1F686; Train Trips Report</h1>
          <p class="subtitle">UMBB - Faculty of Sciences | Module: L3 DSS | 2025/2026</p>
        </header>
        <p class="watermark">TP_Do not copy directly / This page is implemented by the student : ... name ... / Group : ...</p>

        <xsl:apply-templates select="transport/lines/line"/>

        <footer>
          <p>Generated from transport.xml via XSLT &#x2014; Railway Trip Management Project</p>
        </footer>
      </body>
    </html>
  </xsl:template>

  <!-- Template for each line -->
  <xsl:template match="line">
    <xsl:variable name="dep-name" select="key('station-by-id', @departure)/@name"/>
    <xsl:variable name="arr-name" select="key('station-by-id', @arrival)/@name"/>
    <div class="line-card">
      <div class="line-header">
        <h2>
          Line: <xsl:value-of select="@code"/>
          (
          <xsl:value-of select="$dep-name"/>
          <span class="arrow"> &#x2192; </span>
          <xsl:value-of select="$arr-name"/>
          )
        </h2>
      </div>
      <div class="line-body">
        <p class="detail-label">Detailed List of Trips:</p>
        <xsl:apply-templates select="trips/trip">
          <xsl:with-param name="dep-name" select="$dep-name"/>
          <xsl:with-param name="arr-name" select="$arr-name"/>
        </xsl:apply-templates>
      </div>
    </div>
  </xsl:template>

  <!-- Template for each trip -->
  <xsl:template match="trip">
    <xsl:param name="dep-name"/>
    <xsl:param name="arr-name"/>
    <div class="trip-block">
      <p class="trip-title">
        Trip No. <xsl:value-of select="@code"/>:
        departure: <xsl:value-of select="$dep-name"/>
        <span>|</span>
        Arrival: <xsl:value-of select="$arr-name"/>
      </p>
      <table>
        <thead>
          <tr>
            <th>Schedule</th>
            <th>Train Type</th>
            <th>Class</th>
            <th>Price (DA)</th>
          </tr>
        </thead>
        <tbody>
          <xsl:variable name="dep-time" select="schedule/@departure"/>
          <xsl:variable name="arr-time" select="schedule/@arrival"/>
          <xsl:variable name="type"     select="@type"/>
          <xsl:for-each select="class">
            <xsl:choose>
              <xsl:when test="@type='VIP'">
                <tr class="vip-row">
                  <td><xsl:value-of select="$dep-time"/> - <xsl:value-of select="$arr-time"/></td>
                  <td><xsl:value-of select="$type"/></td>
                  <td><strong>VIP</strong></td>
                  <td><xsl:value-of select="@price"/></td>
                </tr>
              </xsl:when>
              <xsl:otherwise>
                <tr>
                  <td><xsl:value-of select="$dep-time"/> - <xsl:value-of select="$arr-time"/></td>
                  <td><xsl:value-of select="$type"/></td>
                  <td><xsl:value-of select="@type"/></td>
                  <td><xsl:value-of select="@price"/></td>
                </tr>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </tbody>
      </table>
      <span class="days-tag">&#x1F4C5; Days: <xsl:value-of select="days"/></span>
    </div>
  </xsl:template>

</xsl:stylesheet>
