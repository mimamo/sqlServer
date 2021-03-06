USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMobileSearchDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMobileSearchDelete]
	@MobileSearchKey int,
	@UserKey int
AS

Declare @Standard tinyint, @StdKey int, @CompanyKey int

Select @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey) from tUser (nolock) Where UserKey = @UserKey

Select @Standard = StandardSearch, @StdKey = StdSearchKey From tMobileSearch (nolock) Where MobileSearchKey = @MobileSearchKey
if @Standard = 1
BEGIN
	-- need different handling for the standard searches
	-- This is a straigt delete of a standard, so tag it to the user and mark it as deleted.
	INSERT tMobileSearch
		(
		CompanyKey,
		ListID,
		UserKey,
		SearchName,
		SortField,
		GroupField,
		Deleted
		)
	Select
		@CompanyKey,
		ListID,
		@UserKey,
		SearchName,
		SortField,
		GroupField,
		1
	From tMobileSearch
	Where MobileSearchKey = @MobileSearchKey 


END

if @Standard = 0 and ISNULL(@StdKey, 0) > 0
BEGIN
	-- This is a copy of a std search
	DELETE FROM tMobileSearchCondition WHERE
		MobileSearchKey = @MobileSearchKey 

	-- keep a place holder around to show it was deleted for this user
	Update tMobileSearch 
	Set Deleted = 1
	WHERE
		MobileSearchKey = @MobileSearchKey 

END

if @Standard = 0 and ISNULL(@StdKey, 0) = 0
BEGIN
	-- normal handling
	DELETE FROM tMobileSearchCondition WHERE
		MobileSearchKey = @MobileSearchKey 

	DELETE FROM tMobileSearch WHERE
		MobileSearchKey = @MobileSearchKey 

END
GO
