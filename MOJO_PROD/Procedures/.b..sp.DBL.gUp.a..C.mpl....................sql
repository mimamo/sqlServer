USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDBLogUpdateComplete]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDBLogUpdateComplete]
	(
	@DBLogKey int
	)
AS

Update tDBLog Set CompleteTime = GETDATE() Where DBLogKey = @DBLogKey
GO
