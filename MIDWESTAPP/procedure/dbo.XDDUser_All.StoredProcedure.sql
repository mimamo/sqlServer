USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDUser_All]    Script Date: 12/21/2015 15:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[XDDUser_All]
 	@UserID  	varchar( 47 )  
AS  
	SELECT		*   
 	FROM		XDDUser
 	WHERE		XDDUser.UserID LIKE @UserID  
 	ORDER BY  	XDDUser.UserID
GO
