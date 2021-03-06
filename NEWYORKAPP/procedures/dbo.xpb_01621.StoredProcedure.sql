USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xpb_01621]    Script Date: 12/21/2015 16:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--UPDATED to T-SQL Standard 03/25/2009 MSB

CREATE PROCEDURE [dbo].[xpb_01621] @RI_ID SMALLINT 

AS

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

--DECLARE @RI_ID int
--SET @RI_ID = 558

BEGIN TRY
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
      SET @StdSelect = 'RPTRI_ID = ' + RTRIM(CONVERT(VARCHAR(6),@RI_ID)) +                               
                       ' AND (PeriodActivity <> 0.00 OR GLBatNbr<>'''') '+ ' AND FiscYr = ''' + @BegPerYr + ''' ' 
   ELSE
      SET @StdSelect = 'RPTRI_ID = ' + RTRIM(CONVERT(VARCHAR(6),@RI_ID)) +                               
                       ' AND (PeriodActivity <> 0.00 OR GLBatNbr<>'''') '+ ' AND FiscYr BETWEEN ''' + @BegPerYr + ''' AND ''' + @EndPerYr + ''' '            
ELSE
   IF @BegPerYr = @EndPerYr 
      SET @StdSelect = 'RPTRI_ID = ' + RTRIM(CONVERT(VARCHAR(6),@RI_ID)) +                               
                       ' AND FiscYr = ''' + @BegPerYr + ''' '  
   ELSE
      SET @StdSelect = 'RPTRI_ID = ' + RTRIM(CONVERT(VARCHAR(6),@RI_ID)) +   
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

SELECT @RI_WHERE = REPLACE(@RI_WHERE,'x01621.','')
--SELECT @RI_WHERE = REPLACE(@RI_WHERE,'xvr_01621B.','')

-- Update the RI_Where field of RptRuntime for this report's RI_ID with the updated @RI_Where variable.
-- If the updated @RI_Where exceeds the 255 character field limit then an ‘RaiseError’ is issued so the 
-- user is aware of this limitation.  When this occurs the @RI_Where is set to the standard selection 
-- criteria to ensure the report will execute correctly. 

UPDATE RptRunTime 
SET RI_Where = CASE WHEN DATALENGTH(@RI_Where) = 0 THEN
                         @StdSelect 
                    ELSE
                         RTRIM(@StdSelect) + ' AND (' + RTRIM(@RI_WHERE) + ')'
               END
WHERE (RI_ID = @RI_ID)


END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK

DECLARE @ErrorNumberA int
DECLARE @ErrorSeverityA int
DECLARE @ErrorStateA varchar(255)
DECLARE @ErrorProcedureA varchar(255)
DECLARE @ErrorLineA int
DECLARE @ErrorMessageA varchar(max)
DECLARE @ErrorDateA smalldatetime
DECLARE @UserNameA varchar(50)
DECLARE @ErrorAppA varchar(50)
DECLARE @UserMachineName varchar(50)

SET @ErrorNumberA = Error_number()
SET @ErrorSeverityA = Error_severity()
SET @ErrorStateA = Error_state()
SET @ErrorProcedureA = Error_procedure()
SET @ErrorLineA = Error_line()
SET @ErrorMessageA = Error_message()
SET @ErrorDateA = GetDate()
SET @UserNameA = suser_sname() 
SET @ErrorAppA = app_name()
SET @UserMachineName = host_name()

EXEC dbo.xLogErrorandEmail @ErrorNumberA, @ErrorSeverityA, @ErrorStateA , @ErrorProcedureA, @ErrorLineA, @ErrorMessageA
, @ErrorDateA, @UserNameA, @ErrorAppA, @UserMachineName

END CATCH


IF @@TRANCOUNT > 0
COMMIT TRANSACTION

END
GO
