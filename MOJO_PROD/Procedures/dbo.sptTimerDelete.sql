USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimerDelete]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimerDelete]
	(
	@TimerKey int
	)
AS

Delete tTimer Where TimerKey = @TimerKey
GO
