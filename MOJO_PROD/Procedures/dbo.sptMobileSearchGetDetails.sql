USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMobileSearchGetDetails]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMobileSearchGetDetails]
	(
	@MobileSearchKey int
	)
	
AS



Select * from tMobileSearch (nolock) Where MobileSearchKey = @MobileSearchKey

Select * from tMobileSearchCondition (nolock) Where MobileSearchKey = @MobileSearchKey
GO
