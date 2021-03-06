USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingScheduleInsert]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingScheduleInsert]
	@ProjectKey int,
	@NextBillDate smalldatetime,
	@TaskKey int,
	@Comments varchar(4000),
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tBillingSchedule
		(
		ProjectKey,
		NextBillDate,
		TaskKey,
		Comments
		)

	VALUES
		(
		@ProjectKey,
		@NextBillDate,
		@TaskKey,
		@Comments
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
