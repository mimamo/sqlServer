USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvExport_Time]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvExport_Time]

	(
		@CompanyKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@IncludeDownloaded tinyint
	)

AS --Encrypt


IF @StartDate IS NULL
 Select @StartDate = '1/1/1990'
 
 
IF @EndDate IS NULL
 Select @EndDate = GETDATE()


select 
	* ,
	NEWID() as TicketNumber
from 
	vExport_Time (NOLOCK)
where
	CompanyKey = @CompanyKey and
	WorkDate >= @StartDate and
	WorkDate <= @EndDate and
	Downloaded <= @IncludeDownloaded
GO
