USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XS_PrivacyManager_User_Scrn]    Script Date: 12/21/2015 15:37:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[XS_PrivacyManager_User_Scrn] 
@parm1 as Varchar(47),
@parm2 as varchar(7),
@parm3 as varchar(5),
@parm4 as varchar(2)
As
Select * from XS_PrivacyManager where UserId = @parm1 and
ScreenId in (@parm2, @parm3, @parm4, '<ALL>')
Order by Userid, ScreenId desc
GO
