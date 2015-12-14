USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRecurTranUserUpdate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRecurTranUserUpdate]
	(
	@RecurTranKey int,
	@UserKey int,
	@Selected tinyint
	)
AS


if @Selected = 0
	Delete tRecurTranUser Where RecurTranKey = @RecurTranKey and UserKey = @UserKey
else
BEGIN
	if not exists(Select 1 from tRecurTranUser Where RecurTranKey = @RecurTranKey and UserKey = @UserKey)
		Insert tRecurTranUser(RecurTranKey, UserKey) Values (@RecurTranKey, @UserKey)


END
GO
