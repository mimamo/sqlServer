USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBCodeInsert]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBCodeInsert]
	@CompanyKey int,
	@ProjectNumber varchar(100),
	@TaskNumber varchar(100),	
	@Active tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel     What
|| 03/07/08  GHL 8.5.0.6 LLNL 2008 CBCode to Project/Task conversion
*/

	IF EXISTS (SELECT 1
				FROM  tCBCode (NOLOCK)
				WHERE CompanyKey = @CompanyKey
				And LTRIM(RTRIM(UPPER(ProjectNumber))) = LTRIM(RTRIM(UPPER(@ProjectNumber)))
				And LTRIM(RTRIM(UPPER(TaskNumber))) = LTRIM(RTRIM(UPPER(@TaskNumber)))
				)
		RETURN -1
				
	INSERT tCBCode
		(
		CompanyKey,
		ProjectNumber,
		TaskNumber,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@ProjectNumber,
		@TaskNumber,
		@Active
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
