USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportGroupUpdate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReportGroupUpdate]
	@ReportGroupKey int,
	@CompanyKey int,
	@GroupName varchar(300),
	@GroupType smallint,
	@DisplayOrder int,
	@Action varchar(10) = 'update'

AS --Encrypt
  /*
  || When     Who Rel      What
  || 08/26/09 MAS 10.5.0.8 Added insert logic
  */
  
IF @ReportGroupKey <= 0
	BEGIN
		INSERT tReportGroup
				(
				CompanyKey,
				GroupName,
				GroupType,
				DisplayOrder
				)

		VALUES
				(
				@CompanyKey,
				@GroupName,
				@GroupType,
				@DisplayOrder
				)

		RETURN @@IDENTITY		
	END
ELSE
	BEGIN
		UPDATE
			tReportGroup
		SET
			CompanyKey = @CompanyKey,
			GroupName = @GroupName,
			GroupType = @GroupType,
			DisplayOrder = @DisplayOrder
		WHERE
			ReportGroupKey = @ReportGroupKey 

		RETURN @ReportGroupKey
	END
GO
