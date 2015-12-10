USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepDefInsert]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepDefInsert]
	@CompanyKey int,
	@Entity varchar(50),
	@EntityKey int,
	@Subject varchar(100),
	@Action smallint,
	@Instructions varchar(1000),
	@EnableRouting tinyint,
	@AllApprove tinyint,
	@DaysToApprove int,
	@oIdentity INT OUTPUT
AS --Encrypt

Declare @DisplayOrder int

	Select @DisplayOrder = ISNULL(Max(DisplayOrder), 0) + 1 from tApprovalStepDef (nolock) Where Entity = @Entity and EntityKey = @EntityKey

	INSERT tApprovalStepDef
		(
		CompanyKey,
		Entity,
		EntityKey,
		Subject,
		DisplayOrder,
		Action,
		Instructions,
		EnableRouting,
		AllApprove,
		DaysToApprove
		)

	VALUES
		(
		@CompanyKey,
		@Entity,
		@EntityKey,
		@Subject,
		@DisplayOrder,
		@Action,
		@Instructions,
		@EnableRouting,
		@AllApprove,
		@DaysToApprove
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
