USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepDefUpdate]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepDefUpdate]
	@ApprovalStepDefKey int,
	@CompanyKey int,
	@Entity varchar(50),
	@EntityKey int,
	@Subject varchar(100),
	@Action smallint,
	@Instructions varchar(1000),
	@EnableRouting tinyint,
	@AllApprove tinyint,
	@DaysToApprove int

AS --Encrypt

	UPDATE
		tApprovalStepDef
	SET
		CompanyKey = @CompanyKey,
		Entity = @Entity,
		EntityKey = @EntityKey,
		Subject = @Subject,
		Action = @Action,
		Instructions = @Instructions,
		EnableRouting = @EnableRouting,
		AllApprove = @AllApprove,
		DaysToApprove = @DaysToApprove
	WHERE
		ApprovalStepDefKey = @ApprovalStepDefKey 

	RETURN 1
GO
