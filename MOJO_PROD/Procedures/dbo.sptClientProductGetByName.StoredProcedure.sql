USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClientProductGetByName]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClientProductGetByName]
	 @CompanyKey int,
	 @ClientKey int,
	 @ClientDivisionKey int,
	 @ProductName varchar(300)
AS

/*
|| When     Who Rel     What
|| 04/02/13 RLB	10.566	Created	for enhancement (170097)
|| 09/06/13 MFT 10.571  Wrapped ClientDivisionKey in ISNULL to allow for Products not in a Division
|| 10/23/14 MFT 10.585  Changed ClientDivisionKey compare to allow for Products in specified Division OR no Division
*/


	SELECT *
		FROM tClientProduct (nolock)
		WHERE CompanyKey = @CompanyKey
		AND ClientKey = @ClientKey
		AND ISNULL(ClientDivisionKey, ISNULL(@ClientDivisionKey, -1)) = ISNULL(@ClientDivisionKey, -1)
		AND UPPER(ProductName) = UPPER(@ProductName)
		
RETURN 1
GO
