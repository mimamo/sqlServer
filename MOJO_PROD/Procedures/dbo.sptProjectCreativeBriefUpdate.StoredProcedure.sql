USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectCreativeBriefUpdate]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectCreativeBriefUpdate]
	@ProjectKey int,
	@Subject1 varchar(200),
	@Description1 text,
	@Subject2 varchar(200),
	@Description2 text,
	@Subject3 varchar(200),
	@Description3 text,
	@Subject4 varchar(200),
	@Description4 text,
	@Subject5 varchar(200),
	@Description5 text,
	@Subject6 varchar(200),
	@Description6 text,
	@Subject7 varchar(200),
	@Description7 text,
	@Subject8 varchar(200),
	@Description8 text,
	@Subject9 varchar(200),
	@Description9 text,
	@Subject10 varchar(200),
	@Description10 text,
	@Subject11 varchar(200),
	@Description11 text,
	@Subject12 varchar(200),
	@Description12 text

AS --Encrypt

/*
|| When      Who Rel     What
|| 2/25/08   CRG 1.0.0.0 Modified the Description parameters to be text to match the table.
*/

If Exists(Select 1 from tProjectCreativeBrief (NOLOCK) Where ProjectKey = @ProjectKey)

	UPDATE
		tProjectCreativeBrief
	SET
		Subject1 = @Subject1,
		Description1 = @Description1,
		Subject2 = @Subject2,
		Description2 = @Description2,
		Subject3 = @Subject3,
		Description3 = @Description3,
		Subject4 = @Subject4,
		Description4 = @Description4,
		Subject5 = @Subject5,
		Description5 = @Description5,
		Subject6 = @Subject6,
		Description6 = @Description6,
		Subject7 = @Subject7,
		Description7 = @Description7,
		Subject8 = @Subject8,
		Description8 = @Description8,
		Subject9 = @Subject9,
		Description9 = @Description9,
		Subject10 = @Subject10,
		Description10 = @Description10,
		Subject11 = @Subject11,
		Description11 = @Description11,
		Subject12 = @Subject12,
		Description12 = @Description12
	WHERE
		ProjectKey = @ProjectKey 
else
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
		Description8,
		Subject9,
		Description9,
		Subject10,
		Description10,
		Subject11,
		Description11,
		Subject12,
		Description12
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
		@Description8,
		@Subject9,
		@Description9,
		@Subject10,
		@Description10,
		@Subject11,
		@Description11,
		@Subject12,
		@Description12
		)
GO
