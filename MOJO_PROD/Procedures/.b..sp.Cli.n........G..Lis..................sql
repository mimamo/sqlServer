USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClientProductGetList]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClientProductGetList]

	@ClientKey int


AS --Encrypt

		SELECT tClientProduct.*, tClientDivision.DivisionName AS DivisionName
		FROM   tClientProduct (nolock) LEFT OUTER JOIN tClientDivision (nolock) ON tClientProduct.ClientDivisionKey = tClientDivision.ClientDivisionKey
		WHERE  tClientProduct.ClientKey = @ClientKey
		Order By tClientProduct.ProductName

	RETURN 1
GO
