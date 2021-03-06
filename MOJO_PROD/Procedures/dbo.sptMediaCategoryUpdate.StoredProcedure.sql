USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaCategoryUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaCategoryUpdate]
	@MediaCategoryKey int,
	@CompanyKey int,
	@ItemKey int,
	@POKind smallint,
	@CategoryID varchar(50),
	@CategoryName varchar(1000),
	@CategoryShortName varchar(100),
	@Description varchar(MAX),
	@Active tinyint
	

AS --Encrypt
/*
|| When      Who Rel      What
|| 06/03/13  MAS 10.5.6.9 Created
|| 02/21/14  PLC 10.5.7.7 Added Broadcast Type
|| 03/04/14  PLC 10.5.7.7 Removed Broadcast Type
*/

if exists(Select 1 from tMediaCategory (nolock) 
		  Where CompanyKey = @CompanyKey 
		  AND CategoryID = @CategoryID
		  AND ISNULL(ItemKey, 0) = ISNULL(@ItemKey, 0)
		  AND MediaCategoryKey <> @MediaCategoryKey)
	Return -1

IF 	@MediaCategoryKey <= 0
	BEGIN
		INSERT tMediaCategory
			(
			CompanyKey,
			ItemKey,
			POKind,
			CategoryID,
			CategoryName,
			CategoryShortName,
			Description,
			Active
			)

		VALUES
			(
			@CompanyKey,
			@ItemKey,
			@POKind,
			@CategoryID,
			@CategoryName,
			@CategoryShortName,
			@Description,
			@Active
			)
		
		RETURN @@IDENTITY
	END
ELSE
	BEGIN
		UPDATE
			tMediaCategory
		SET
			ItemKey = @ItemKey,
			CategoryID = @CategoryID,
			CategoryName = @CategoryName,
			CategoryShortName = @CategoryShortName,
			Description = @Description,
			Active = @Active
		WHERE
			MediaCategoryKey = @MediaCategoryKey 

		RETURN @MediaCategoryKey
	END
GO
