USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarTypeUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarTypeUpdate]
	@CalendarTypeKey int,
	@CompanyKey int,
	@TypeName varchar(200),
	@TypeColor varchar(50),
	@DisplayOrder int

AS --Encrypt

/*
|| When      Who Rel      What
|| 09/04/09  MAS 10.5.0.9 Added insert logic

*/

IF @CalendarTypeKey <= 0
	BEGIN
		INSERT tCalendarType
			(
			CompanyKey,
			TypeName,
			TypeColor,
			DisplayOrder
			)

		VALUES
			(
			@CompanyKey,
			@TypeName,
			@TypeColor,
			@DisplayOrder
			)
		
		RETURN @@IDENTITY
	END
ELSE
	BEGIN
		UPDATE
			tCalendarType
		SET
			CompanyKey = @CompanyKey,
			TypeName = @TypeName,
			TypeColor = @TypeColor,
			DisplayOrder = @DisplayOrder
		WHERE
			CalendarTypeKey = @CalendarTypeKey 

		RETURN @CalendarTypeKey
	END
GO
