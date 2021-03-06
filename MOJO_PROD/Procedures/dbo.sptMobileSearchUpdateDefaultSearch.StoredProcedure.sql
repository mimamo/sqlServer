USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMobileSearchUpdateDefaultSearch]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMobileSearchUpdateDefaultSearch]
	(
	@CompanyKey int,
	@UserKey int,
	@ListID varchar(100),
	@MobileSearchKey int
	)

AS


if exists(Select 1 from tMobileSearchDefault (nolock) Where UserKey = @UserKey and ListID = @ListID)
	Update tMobileSearchDefault Set MobileSearchKey = @MobileSearchKey Where UserKey = @UserKey and ListID = @ListID
else
	Insert tMobileSearchDefault (CompanyKey, UserKey, ListID, MobileSearchKey)
	Values (@CompanyKey, @UserKey, @ListID, @MobileSearchKey)
GO
