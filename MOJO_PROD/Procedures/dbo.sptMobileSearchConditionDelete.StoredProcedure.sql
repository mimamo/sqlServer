USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMobileSearchConditionDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMobileSearchConditionDelete]
	@MobileSearchConditionKey int

AS

	DELETE FROM tMobileSearchCondition WHERE
		MobileSearchConditionKey = @MobileSearchConditionKey
GO
