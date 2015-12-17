USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDUserRec_All_PV]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[XDDUserRec_All_PV]  
 	@UserID  	varchar( 47 )
	WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'

AS  
	declare @Query varchar(255)

	--Execute the query from a variable so this procedure will compile even though the
	--view may not exist

	select @Query = 'SELECT	* FROM vs_UserRec WHERE RecType = ''U'' AND UserId LIKE ''' + @UserID + ''' ORDER BY UserId'

--	select @Query

	execute(@Query)
GO
