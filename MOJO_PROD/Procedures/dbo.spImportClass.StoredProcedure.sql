USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportClass]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportClass]
	@CompanyKey int,
	@ClassID varchar(50),
	@ClassName varchar(200),
	@Description varchar(1000),
	@Active tinyint
AS --Encrypt

if exists(select 1 from tClass (nolock) Where ClassID = @ClassID and CompanyKey = @CompanyKey)
	return -1

	INSERT tClass
		(
		CompanyKey,
		ClassID,
		ClassName,
		Description,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@ClassID,
		@ClassName,
		@Description,
		@Active
		)
	
	RETURN 1
GO
