USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tCalendar (nolock)
		WHERE
		CompanyKey = @CompanyKey

	RETURN 1
GO
