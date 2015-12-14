USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportUserGet]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptReportUserGet]
	@ReportID varchar(50),
	@UserKey int
	
As

Select ReportKey 
From tReportUser (nolock) 
Where ReportID = @ReportID 
and		UserKey = @UserKey
GO
