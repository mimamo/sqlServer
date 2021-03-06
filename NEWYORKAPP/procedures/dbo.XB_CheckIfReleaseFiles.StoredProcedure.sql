USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XB_CheckIfReleaseFiles]    Script Date: 12/21/2015 16:01:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[XB_CheckIfReleaseFiles] 
@RI_ID int
AS
DECLARE @SystemDate as smalldatetime
DECLARE @SystemTime as smalldatetime

Select @SystemDate = cast(systemdate as smalldatetime), @SystemTime = cast(systemtime as smalldatetime) 
From RptRuntime Where RI_ID = @RI_ID

Select Count(*) from RPTRuntime Where ReportNbr = '03620' And RI_ID <> @RI_ID 
And systemdate = @SystemDate
And cast(systemtime as smalldatetime) between dateadd(mi,-2,@SystemTime) 
And dateadd(mi,2,@SystemTime)
GO
