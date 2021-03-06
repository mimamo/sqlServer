USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WC_GetUserPW]    Script Date: 12/21/2015 14:18:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.WC_GetUserPW    Script Date: 1/4/05 5:05:32 PM ******/
CREATE Procedure [dbo].[WC_GetUserPW](
 @UserName  CHAR(60) = null
)As
    -- lookup the user and return the password for validation, also makes sure there is both a WCUser and PJControl
    IF @UserName IS NOT NULL
        SELECT p.control_data
        FROM  WCUser u
 	INNER JOIN PJContrl p on p.Control_Type = 'PW' and
        SUBSTRING(u.UserName, 1, 27) = SUBSTRING(p.Control_Code, 3, 27) and
        SUBSTRING(u.UserName, 28, 13) = SUBSTRING(p.Control_Desc, 1, 13)
	WHERE u.UserName = @UserName
GO
