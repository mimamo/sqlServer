USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportGroupDelete]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReportGroupDelete]
	@ReportGroupKey int

AS --Encrypt
/*
|| When       Who Rel      What
|| 09/29/11   RLB 10.5.4.8 only check WMj reports and Null out old CMP groups
*/

If exists(select 1 from tReport (NOLOCK) Where ReportGroupKey = @ReportGroupKey AND ApplicationVersion = 2)
	Return -1

UPDATE tReport set ReportGroupKey = NULL WHERE  ReportGroupKey = @ReportGroupKey AND ApplicationVersion = 1

	DELETE
	FROM tReportGroup
	WHERE
		ReportGroupKey = @ReportGroupKey 

	RETURN 1
GO
