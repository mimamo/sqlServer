USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClassInsert]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClassInsert]
	@CompanyKey int,
	@ClassID varchar(50),
	@ClassName varchar(200),
	@Description varchar(1000),
	@Active tinyint,
	@OfficeKey int,
	@DepartmentKey int,
	@oIdentity INT OUTPUT
AS --Encrypt

if exists(select 1 from tClass (nolock) Where ClassID = @ClassID and CompanyKey = @CompanyKey)
	return -1

	INSERT tClass
		(
		CompanyKey,
		ClassID,
		ClassName,
		Description,
		Active,
		DepartmentKey,
		OfficeKey
		)

	VALUES
		(
		@CompanyKey,
		@ClassID,
		@ClassName,
		@Description,
		@Active,
		@DepartmentKey,
		@OfficeKey
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
