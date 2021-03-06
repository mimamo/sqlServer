USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDUserRec_UserName]    Script Date: 12/21/2015 15:37:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[XDDUserRec_UserName]
 	@RecType	varchar( 1 ),
 	@UserID  	varchar( 47 )
	WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'

AS  
	SELECT		UserName
 	FROM		vs_UserRec
 	WHERE		RecType = @RecType
 			and UserID LIKE @UserID
 	ORDER BY  	UserID
GO
