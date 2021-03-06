USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMobileSearchUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMobileSearchUpdate]
	@MobileSearchKey int,
	@CompanyKey int,
	@ListID varchar(100),
	@UserKey int,
	@SearchName varchar(1000),
	@SortField varchar(200),
	@SortDirection varchar(20),
	@GroupField varchar(200)

AS

/*
|| When       Who Rel      What
|| 02/08/11   GHL 10.5.4.1 Removed update of DefaultSearch
*/

Declare @Standard tinyint, @StdKey int

IF @MobileSearchKey <= 0
BEGIN

	INSERT tMobileSearch
		(
		CompanyKey,
		ListID,
		UserKey,
		SearchName,
		SortField,
		SortDirection,
		GroupField
		)

	VALUES
		(
		@CompanyKey,
		@ListID,
		@UserKey,
		@SearchName,
		@SortField,
		@SortDirection,
		@GroupField
		)
		Select @MobileSearchKey = @@IDENTITY

END
ELSE
BEGIN

	Select @Standard = StandardSearch, @StdKey = StdSearchKey From tMobileSearch (nolock) Where MobileSearchKey = @MobileSearchKey
	
	if @Standard = 1
	BEGIN
		INSERT tMobileSearch
			(
			CompanyKey,
			ListID,
			UserKey,
			SearchName,
			SortField,
			SortDirection,
			GroupField,
			StdSearchKey
			)
		VALUES (
			@CompanyKey,
			@ListID,
			@UserKey,
			@SearchName,
			@SortField,
			@SortDirection,
			@GroupField,
			@StdKey
			)

		Select @MobileSearchKey = @@IDENTITY

	END
	ELSE
	BEGIN

		UPDATE
			tMobileSearch
		SET
			CompanyKey = @CompanyKey,
			ListID = @ListID,
			UserKey = @UserKey,
			SearchName = @SearchName,
			SortField = @SortField,
			SortDirection = @SortDirection,
			GroupField = @GroupField
		WHERE
			MobileSearchKey = @MobileSearchKey 
	END

END

return @MobileSearchKey
GO
