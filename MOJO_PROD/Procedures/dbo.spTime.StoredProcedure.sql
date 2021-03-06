USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spTime]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTime]
	(
		@msg varchar(50)
		,@t1 datetime output
	)
AS 
	SET NOCOUNT ON
			
	declare @t2 datetime
	select @t2 = getdate()
	select @msg, datediff(ms, @t1, @t2)
	select @t1 = @t2
	
	RETURN 1
GO
