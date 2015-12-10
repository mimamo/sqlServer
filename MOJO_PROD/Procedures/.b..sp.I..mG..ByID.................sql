USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemGetByID]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemGetByID]
	@CompanyKey int,
	@ItemID varchar(50)

AS --Encrypt


	SELECT *
	FROM tItem i (nolock) 
	WHERE
		i.CompanyKey = @CompanyKey and
		i.ItemID = @ItemID

	RETURN 1
GO
