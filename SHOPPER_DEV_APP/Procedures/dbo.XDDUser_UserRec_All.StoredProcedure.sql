USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDUser_UserRec_All]    Script Date: 12/21/2015 14:34:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[XDDUser_UserRec_All]  
 	@UserID  	varchar( 47 )  
	WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'

AS  
	SELECT		*   
 	FROM		XDDUser LEFT OUTER JOIN vs_UserRec
 			ON XDDUser.UserID = vs_UserRec.UserID
 	WHERE		XDDUser.UserID LIKE @UserID  
 	ORDER BY  	XDDUser.UserID
GO
