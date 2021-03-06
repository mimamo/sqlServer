USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportProjectType]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportProjectType]
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
	@ProjectNumPrefix varchar(20),
	@NextProjectNum int
AS --Encrypt

if exists(select 1 from tProjectType (nolock) Where CompanyKey = @CompanyKey and ProjectTypeName = @ProjectTypeName)
	Return -1

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
		@ProjectNumPrefix,
		@NextProjectNum
		)
	
	RETURN 1
GO
