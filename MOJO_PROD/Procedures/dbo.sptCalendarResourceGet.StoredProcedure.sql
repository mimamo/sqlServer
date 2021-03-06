USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarResourceGet]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarResourceGet]
	@CompanyKey int,	
	@CalendarResourceKey int = 0

AS
	-- ToDo: If there is more than one PrimaryKey, remove the extras or rewrite the If statement.
	IF @CalendarResourceKey =0 
		SELECT *
		FROM 	tCalendarResource (nolock)
		where CompanyKey = @CompanyKey 	
	ELSE

		SELECT *
		FROM tCalendarResource (nolock)
		WHERE
			CalendarResourceKey = @CalendarResourceKey
			and 
			CompanyKey = @CompanyKey	
	RETURN 1
GO
