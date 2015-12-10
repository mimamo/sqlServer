USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectChangeLockStatus]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectChangeLockStatus]
	(
		@ProjectKey int,
		@UserKey int
	)

AS


Update tProject Set ScheduleLockedByKey = @UserKey Where ProjectKey = @ProjectKey
GO
