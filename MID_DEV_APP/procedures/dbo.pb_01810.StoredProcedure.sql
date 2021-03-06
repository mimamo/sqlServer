USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pb_01810]    Script Date: 12/21/2015 14:17:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pb_01810] @RI_ID SMALLINT AS

   DECLARE @OrigRI_Where   VARCHAR(255),
           @RI_Where       VARCHAR(255),
           @StdSelect      VARCHAR(255),
           @FoundInRIWhere SMALLINT,
           @BegPerNbr      VARCHAR(6),
           @EndPerNbr      VARCHAR(6),
           @CalledByProg   SMALLINT

   SELECT @OrigRI_Where = LTRIM(RTRIM(RI_Where)),
          @RI_Where     = LTRIM(RTRIM(RI_Where)),
          @BegPerNbr    = BegPerNbr,
          @EndPerNbr    = EndPerNbr
   FROM RptRunTime
   WHERE RI_ID = @RI_ID

   --  If *pROI* in the first 6 positions then report is being called programmatically
   --  otherwise it is being called by ROI.  If being called programmatically the
   --  pre-process will strip off the '*pROI*' from the RI_Where field and allow the report
   --  to continue.  If being called interactively then build the @StdSelect string to be the
   --  standard selection criteria for the GL Edit Report.
   --
   --  NOTE:  this procedure is done to 'push' the selection criteria to the server-side for
   --         performance.  Otherwise Crystal would bring the records to the client and then
   --         enforce the selection criteria.  Populating the RI_Where field will allow ROI
   --         to pick up this field and send to the server as part of the initial SQL request.

   -- Determine if report was called programmatically.
   IF SUBSTRING(@RI_Where, 1, 6) = '*pROI*'
      BEGIN
      -- If called programmatically then strip off the 'flag' characters '*pROI*'.
         SET @CalledByProg = 1
         SET @StdSelect = 'RPT_Company_RI_ID = ' + RTRIM(CONVERT(VARCHAR(6),@RI_ID)) + ' AND ' + SUBSTRING(@RI_Where, 7, 218)
      END
   ELSE
      BEGIN
         -- Build the standard GL Edit Report selection string.
         SET @CalledByProg = 0
         SET @StdSelect = '(RPT_Company_RI_ID = ' + RTRIM(CONVERT(VARCHAR(6),@RI_ID)) + ' AND Batch_Module = ''GL''' +
                          ' AND Batch_PerPost >= ''' + @BegPerNbr + ''' AND Batch_PerPost <= ''' + @EndPerNbr + ''')'
      END

   -- Update the RI_Where field of RptRuntime for this report's RI_ID with the updated @RI_Where variable.
   -- If the updated @RI_Where exceeds the 254 character field limit then an ?RaiseError? is issued so the
   -- user is aware of this limitation.  When this occurs the @RI_Where is set to the standard selection
   -- criteria to ensure the report will execute correctly.
   UPDATE RptRuntime
   SET RI_Where =  CASE WHEN (@CalledByProg = 1) THEN
                             @StdSelect
                        WHEN (@CalledByProg = 0 AND DATALENGTH(@RI_Where) = 0) THEN
                             @StdSelect
                        WHEN (@CalledByProg = 0 AND DATALENGTH(@RI_Where) > 0 AND
                             (DATALENGTH(@StdSelect) + (DATALENGTH(@RI_Where) + 7) <= 254)) THEN
                             @StdSelect + ' AND (' + @RI_WHERE + ')'
                        ELSE
                             @StdSelect
                       END
   WHERE (RI_ID = @RI_ID)
GO
