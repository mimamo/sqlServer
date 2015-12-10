USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadDeliverables]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[spProjectLoadDeliverables]
(
	@ProjectKey int
)

as 

	Select ReviewDeliverableKey, DeliverableName
	From tReviewDeliverable (nolock)
	Where ProjectKey = @ProjectKey
	Order By DeliverableName
GO
