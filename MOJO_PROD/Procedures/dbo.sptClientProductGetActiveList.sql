USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClientProductGetActiveList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClientProductGetActiveList]

	@ClientKey int


AS --Encrypt
		
		SELECT tClientProduct.*, tClientDivision.DivisionName AS DivisionName
		FROM   tClientProduct (nolock) LEFT OUTER JOIN tClientDivision (nolock) ON tClientProduct.ClientDivisionKey = tClientDivision.ClientDivisionKey
		WHERE tClientProduct.ClientKey = @ClientKey
		and tClientProduct.Active = 1
		Order By tClientProduct.ProductName

	RETURN 1
GO
