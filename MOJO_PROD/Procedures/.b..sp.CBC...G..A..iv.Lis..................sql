USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBCodeGetActiveList]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBCodeGetActiveList]

	@CompanyKey int,
	@CBCode varchar(400)


AS --Encrypt

if @CBCode is null
		SELECT *
		FROM tCBCode (nolock)
		WHERE
		CompanyKey = @CompanyKey and Active = 1
		Order By CBCode
else
		SELECT *
		FROM tCBCode (nolock)
		WHERE
		CompanyKey = @CompanyKey and Active = 1 and CBCode = @CBCode
		Order By CBCode
		
	RETURN 1
GO
