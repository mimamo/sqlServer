USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarResourceUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarResourceUpdate]
	@CalendarResourceKey int,
	@ResourceName varchar(200),
	@CompanyKey int


AS --Encrypt
/*
|| When      Who Rel      What
|| 09/09/09  MAS 10.5.0.9 Added insert logic

*/

IF @CalendarResourceKey <= 0 
	BEGIN
		INSERT tCalendarResource
			(
			ResourceName,
			CompanyKey
			)
		VALUES
			(
			@ResourceName,
			@CompanyKey
			)
	 
		 RETURN @@IDENTITY
	END
ELSE
	BEGIN 
	 
		UPDATE
			tCalendarResource
		SET
			ResourceName = @ResourceName,
			CompanyKey = @CompanyKey

		WHERE
			CalendarResourceKey = @CalendarResourceKey 

		RETURN @CalendarResourceKey
	END
GO
