USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDUserRec_Approver1_PV]    Script Date: 12/21/2015 15:43:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[XDDUserRec_Approver1_PV]
 	@UserID  	varchar( 47 )
	WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
AS  

	SELECT		*   
 	FROM		XDDUser
 	WHERE		AmtAppLvl1 = 1
			and UserID LIKE @UserID
 	ORDER BY  	UserID
GO
