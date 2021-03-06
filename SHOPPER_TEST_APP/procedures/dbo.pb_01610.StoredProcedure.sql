USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pb_01610]    Script Date: 12/21/2015 16:07:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pb_01610] @RI_ID SMALLINT AS

DECLARE @RI_Where       VARCHAR(255),
        @StdSelect      VARCHAR(255),
        @BegPerNbr      VARCHAR(6),
        @EndPerNbr      VARCHAR(6),
        @BegPerYr       VarChar(4),
        @EndPerYr       VarChar(4),
        @BegPerMo       VarChar(2),
        @EndPerMo       VarChar(2),
        @Activity1      CHAR(10),
        @Activity2      CHAR(10)

SELECT  @RI_Where       = LTRIM(RTRIM(RI_Where)),
        @BegPerNbr      = BegPerNbr,
        @EndPerNbr      = EndPerNbr,
        @BegPerYr       = SubString(BegPerNbr,1,4),
        @EndPerYr       = SubString(EndPerNbr,1,4),
        @BegPerMo       = SubString(BegPerNbr,5,2),
        @EndPerMo       = SubString(EndPerNbr,5,2),
        @Activity1      = ShortAnswer00,
        @Activity2      = ShortAnswer01


FROM RptRunTime
WHERE RI_ID = @RI_ID

-- To create more space for the Sort/Select criteria, an additional check will be processed if the
-- ROI BegPerYr and the EndPerYr are the same.  If true, then the FiscYr will need to just equal the BegPerYr.  This will
-- eliminate the need for the BETWEEN check.

IF @Activity2 = 'True'
   IF @BegPerYr = @EndPerYr
      SET @StdSelect = 'RPT_Company_RI_ID = ' + RTRIM(CONVERT(VARCHAR(6),@RI_ID)) +
                       ' AND Ending_Balance <> 0.00 '+ ' AND FiscYr = ''' + @BegPerYr + ''' '
   ELSE
      SET @StdSelect = 'RPT_Company_RI_ID = ' + RTRIM(CONVERT(VARCHAR(6),@RI_ID)) +
                       ' AND Ending_Balance <> 0.00 '+ ' AND FiscYr BETWEEN ''' + @BegPerYr + ''' AND ''' + @EndPerYr + ''' '
ELSE
   IF @Activity2 = 'False' and @Activity1 = 'True'
      IF @BegPerYr = @EndPerYr
         SET @StdSelect = 'RPT_Company_RI_ID = ' + RTRIM(CONVERT(VARCHAR(6),@RI_ID)) +
                          ' AND ((DrAmtTot <> 0.00 OR CrAmtTot <> 0.00) '+ ' OR Ending_Balance <> 0.00) '+ ' AND FiscYr = ''' + @BegPerYr + ''' '
     ELSE
       SET @StdSelect = 'RPT_Company_RI_ID = ' + RTRIM(CONVERT(VARCHAR(6),@RI_ID)) +
                      ' AND ((DrAmtTot <> 0.00 OR CrAmtTot <> 0.00) '+ ' OR Ending_Balance <> 0.00) '+ ' AND FiscYr BETWEEN ''' + @BegPerYr + ''' AND ''' + @EndPerYr + ''' '
    ELSE
      IF @BegPerYr = @EndPerYr
         SET @StdSelect = 'RPT_Company_RI_ID = ' + RTRIM(CONVERT(VARCHAR(6),@RI_ID)) +
                          ' AND FiscYr = ''' + @BegPerYr + ''' '
      ELSE
         SET @StdSelect = 'RPT_Company_RI_ID = ' + RTRIM(CONVERT(VARCHAR(6),@RI_ID)) +
                          ' AND FiscYr BETWEEN ''' + @BegPerYr + ''' AND ''' + @EndPerYr + ''' '

-- To create more space for the Sort/Select criteria, the RI_where prefix will be trimmed.  This
-- eliminate unnecessary characters.

SELECT @RI_WHERE = REPLACE(@RI_WHERE,'vr_01610A.','')
SELECT @RI_WHERE = REPLACE(@RI_WHERE,'vr_01610B.','')

-- Update the RI_Where field of RptRuntime for this report's RI_ID with the updated @RI_Where variable.
-- If the updated @RI_Where exceeds the 254 character field limit then an ?RaiseError? is issued so the
-- user is aware of this limitation.  When this occurs the @RI_Where is set to the standard selection
-- criteria to ensure the report will execute correctly.

UPDATE RptRunTime
SET RI_Where = CASE WHEN DATALENGTH(@RI_Where) = 0 THEN
                         @StdSelect
                    ELSE
                         @StdSelect + ' AND (' + @RI_WHERE + ')'
               END
WHERE (RI_ID = @RI_ID)
GO
