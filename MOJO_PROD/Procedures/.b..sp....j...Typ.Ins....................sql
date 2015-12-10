USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTypeInsert]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTypeInsert]
	@CompanyKey int,
	@ProjectTypeName varchar(100),
	@Description varchar(500),
	@Subject1 varchar(200),
	@Subject2 varchar(200),
	@Subject3 varchar(200),
	@Subject4 varchar(200),
	@Subject5 varchar(200),
	@Subject6 varchar(200),
	@Subject7 varchar(200),
	@Subject8 varchar(200),
	@Subject9 varchar(200),
	@Subject10 varchar(200),
	@Subject11 varchar(200),
	@Subject12 varchar(200),
	@ProjectNumPrefix varchar(20),
	@NextProjectNum int,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tProjectType
		(
		CompanyKey,
		ProjectTypeName,
		Description,
		Subject1,
		Subject2,
		Subject3,
		Subject4,
		Subject5,
		Subject6,
		Subject7,
		Subject8,
		Subject9,
		Subject10,
		Subject11,
		Subject12,
		ProjectNumPrefix,
		NextProjectNum		
		)

	VALUES
		(
		@CompanyKey,
		@ProjectTypeName,
		@Description,
		@Subject1,
		@Subject2,
		@Subject3,
		@Subject4,
		@Subject5,
		@Subject6,
		@Subject7,
		@Subject8,
		@Subject9,
		@Subject10,
		@Subject11,
		@Subject12,
		@ProjectNumPrefix,
		@NextProjectNum		
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
