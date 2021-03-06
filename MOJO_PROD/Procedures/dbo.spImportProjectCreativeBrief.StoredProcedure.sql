USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportProjectCreativeBrief]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportProjectCreativeBrief]
	@CompanyKey int,
	@ProjectNumber varchar(50),
	@Subject1 varchar(200),
	@Description1 varchar(2000),
	@Subject2 varchar(200),
	@Description2 varchar(2000),
	@Subject3 varchar(200),
	@Description3 varchar(2000),
	@Subject4 varchar(200),
	@Description4 varchar(2000),
	@Subject5 varchar(200),
	@Description5 varchar(2000),
	@Subject6 varchar(200),
	@Description6 varchar(2000),
	@Subject7 varchar(200),
	@Description7 varchar(2000),
	@Subject8 varchar(200),
	@Description8 varchar(2000)
AS --Encrypt

	Declare	@ProjectKey int
	
	SELECT	@ProjectKey = ProjectKey
	FROM	tProject (nolock)
	WHERE	CompanyKey = @CompanyKey and ProjectNumber = @ProjectNumber
	
	IF @ProjectKey IS NULL
		RETURN -1

	INSERT tProjectCreativeBrief
		(
		ProjectKey,
		Subject1,
		Description1,
		Subject2,
		Description2,
		Subject3,
		Description3,
		Subject4,
		Description4,
		Subject5,
		Description5,
		Subject6,
		Description6,
		Subject7,
		Description7,
		Subject8,
		Description8
		)

	VALUES
		(
		@ProjectKey,
		@Subject1,
		@Description1,
		@Subject2,
		@Description2,
		@Subject3,
		@Description3,
		@Subject4,
		@Description4,
		@Subject5,
		@Description5,
		@Subject6,
		@Description6,
		@Subject7,
		@Description7,
		@Subject8,
		@Description8
		)
	
	RETURN 1
GO
