USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDUser_Class]    Script Date: 12/21/2015 15:43:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[XDDUser_Class]
 	@UserID  	varchar( 47 )  
	WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'

AS  
	SELECT		*   
 	FROM		XDDUser U (nolock) LEFT OUTER JOIN vs_UserRec S (nolock)
 			ON U.UserID = S.UserID and S.RecType = 'U'
 	WHERE		U.UserID LIKE @UserID
GO
