USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingScheduleDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingScheduleDelete]
	@BillingScheduleKey int

AS --Encrypt

	DELETE
	FROM tBillingSchedule
	WHERE
		BillingScheduleKey = @BillingScheduleKey 

	RETURN 1
GO
