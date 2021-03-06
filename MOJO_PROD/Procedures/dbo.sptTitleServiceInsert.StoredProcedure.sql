USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTitleServiceInsert]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTitleServiceInsert]
	(
		@TitleKey int
	   ,@ServiceKey int
	)
AS --Encrypt
/*
|| When       Who Rel      What
|| 09/18/2014 WDF 10.5.8.4 New
*/
if exists(select 1 from tTitle (nolock) where TitleKey = @TitleKey)
begin
	Insert tTitleService
		(
		 TitleKey
		,ServiceKey
		)
	Values
		(
		 @TitleKey
		,@ServiceKey
		)
end

return 1
GO
