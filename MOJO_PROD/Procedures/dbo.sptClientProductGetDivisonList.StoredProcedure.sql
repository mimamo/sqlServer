USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClientProductGetDivisonList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClientProductGetDivisonList]

	@ClientKey int,
	@ClientDivisionKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 9/22/08   CRG 10.0.0.9 (35115) Sometimes 0 is passed in from flex rather than NULL.
*/
		
		if ISNULL(@ClientDivisionKey, 0) = 0
			SELECT *
			FROM  tClientProduct (nolock) 
			WHERE ClientKey = @ClientKey
			and ClientDivisionKey is null   
			and Active = 1
			Order By ProductName
		else
			SELECT *
			FROM  tClientProduct (nolock) 
			WHERE ClientKey = @ClientKey
			and (ClientDivisionKey = @ClientDivisionKey or ClientDivisionKey is null)
			and Active = 1
			Order By ProductName

	RETURN 1
GO
