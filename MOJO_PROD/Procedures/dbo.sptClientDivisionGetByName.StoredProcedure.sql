USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClientDivisionGetByName]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClientDivisionGetByName]
	 @CompanyKey int,
	 @ClientKey int,
	 @DivisionName varchar(300)
AS 

/*
|| When		Who	Rel	What
|| 04/02/13	RLB	10.566	Created	for enhancement (170097)
*/

	
	SELECT * 
	FROM tClientDivision (nolock)
	WHERE CompanyKey = @CompanyKey
		AND ClientKey = @ClientKey
		AND UPPER(DivisionName) = UPPER(@DivisionName) 
	
RETURN 1
GO
