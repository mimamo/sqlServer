USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMobileSearchConditionDelete]    Script Date: 12/10/2015 10:54:13 ******/
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
