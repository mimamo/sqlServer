USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportUpdateFields]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReportUpdateFields]
	@ReportKey int,
	@FieldDefinition text

AS --Encrypt

	UPDATE
		tReport
	SET
		FieldDefinition = @FieldDefinition
	WHERE
		ReportKey = @ReportKey 

	RETURN 1
GO
