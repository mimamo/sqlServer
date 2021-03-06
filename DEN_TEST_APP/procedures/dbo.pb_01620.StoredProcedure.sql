USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pb_01620]    Script Date: 12/21/2015 15:37:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pb_01620] @RI_ID SMALLINT AS

DECLARE @RI_Where       VARCHAR(255),
        @StdSelect      VARCHAR(255),
        @BegPerNbr      VARCHAR(6),
        @EndPerNbr      VARCHAR(6),
        @BegPerYr       VarChar(4),
        @EndPerYr       VarChar(4),
        @BegPerMo       VarChar(2),
        @EndPerMo       VarChar(2),
        @Activity       CHAR(10)

SELECT  @RI_Where       = LTRIM(RTRIM(RI_Where)),
        @BegPerNbr      = BegPerNbr,
        @EndPerNbr      = EndPerNbr,
        @BegPerYr       = SubString(BegPerNbr,1,4),
        @EndPerYr       = SubString(EndPerNbr,1,4),
        @BegPerMo       = SubString(BegPerNbr,5,2),
        @EndPerMo       = SubString(EndPerNbr,5,2),
        @Activity       = ShortAnswer00
FROM RptRunTime
WHERE RI_ID = @RI_ID

-- If the ROI Options tab field 'Print only Accounts with Activity' is checked (@Activity = True)
-- then select off any records with no Period Activity (PTDBAL for period being processed).
-- This indicates there was no activity for the period.
--
-- To create more space for the Sort/Select criteria, an additional check will be processed if the
-- ROI BegPerYr and the EndPerYr are the same then the FiscYr will need to just equal the BegPerYr.  This will
-- eliminate the need for the BETWEEN check.

IF @Activity = 'True'
   IF @BegPerYr = @EndPerYr
      SET @StdSelect = 'RPT_Company_RI_ID = ' + RTRIM(CONVERT(VARCHAR(6),@RI_ID)) +
                       ' AND (Period_Activity <> 0.00 OR GLTran_BatNbr<>'''') '+ ' AND FiscYr = ''' + @BegPerYr + ''' '
   ELSE
      SET @StdSelect = 'RPT_Company_RI_ID = ' + RTRIM(CONVERT(VARCHAR(6),@RI_ID)) +
                       ' AND (Period_Activity <> 0.00 OR GLTran_BatNbr<>'''') '+ ' AND FiscYr BETWEEN ''' + @BegPerYr + ''' AND ''' + @EndPerYr + ''' '
ELSE
   IF @BegPerYr = @EndPerYr
      SET @StdSelect = 'RPT_Company_RI_ID = ' + RTRIM(CONVERT(VARCHAR(6),@RI_ID)) +
                       ' AND FiscYr = ''' + @BegPerYr + ''' '
   ELSE
      SET @StdSelect = 'RPT_Company_RI_ID = ' + RTRIM(CONVERT(VARCHAR(6),@RI_ID)) +
                       ' AND FiscYr BETWEEN ''' + @BegPerYr + ''' AND ''' + @EndPerYr + ''' '

-- For Performance, the year entered will be checked.  If they are the same then add the month index
-- to enhance performance of the query.
--
-- To create more space for the Sort/Select criteria, an additional check will be processed if the
-- ROI BegPerNbr and the EndPerNbr are the same then the Month will need to just equal the BegPerYr.  This will
-- eliminate the need for the BETWEEN check.

IF @BegPerYr = @EndPerYr
  IF @BegPerMo = @EndPerMo
     SET @StdSelect = @StdSelect + 'AND Month = ''' + @BegPerMo + ''' '
  ELSE
    SET @StdSelect = @StdSelect + 'AND Month BETWEEN ''' + @BegPerMo + ''' AND ''' + @EndPerMo + ''' '

-- To create more space for the Sort/Select criteria, the RI_where prefix will be trimmed.  This
-- eliminate unnecessary characters.

SELECT @RI_WHERE = REPLACE(@RI_WHERE,'vr_01620.','')
SELECT @RI_WHERE = REPLACE(@RI_WHERE,'vr_01620MC.','')

-- Update the RI_Where field of RptRuntime for this report's RI_ID with the updated @RI_Where variable.
-- If the updated @RI_Where exceeds the 255 character field limit then an ?RaiseError? is issued so the
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
