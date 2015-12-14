USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClientDivisionGetList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
  || When     Who Rel     What
  || 10/17/06 WES 8.3567  Order By Clause
  */


CREATE  PROCEDURE [dbo].[sptClientDivisionGetList]

	@ClientKey int


AS --Encrypt

		SELECT *
		FROM tClientDivision (nolock)
		WHERE ClientKey = @ClientKey
                Order By DivisionName
	RETURN 1
GO
