USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PStatus_by_UserID_Veiwed]    Script Date: 12/21/2015 16:13:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PStatus_by_UserID_Veiwed    Script Date: 4/17/98 12:50:25 PM ******/
/****** Object:  Stored Procedure dbo.PStatus_by_UserID_Veiwed    Script Date: 4/7/98 12:56:04 PM ******/
Create Proc  [dbo].[PStatus_by_UserID_Veiwed] @parm1 varchar ( 47) as
Select * from PStatus
WHERE UserId   like @parm1
AND   ViewDate = ''
AND   Status            <> 'S'
           order by PID,
                    UserId,
                    InternetAddress
GO
