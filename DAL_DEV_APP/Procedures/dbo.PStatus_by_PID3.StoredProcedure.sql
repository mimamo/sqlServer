USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PStatus_by_PID3]    Script Date: 12/21/2015 13:35:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PStatus_by_PID3    Script Date: 4/7/08 12:50:25 PM ******/
Create Proc  [dbo].[PStatus_by_PID3] @parm1 varchar ( 10), @parm2 varchar ( 47), @parm3 varchar ( 21), @parm4 int as
Select * from PStatus
WHERE PID               like @parm1

AND   UserId            like @parm2
AND   InternetAddress   like @parm3
AND	  RecordID          = @parm4
AND   Status            <> 'S'
           order by PID,
                    UserId,
                    InternetAddress,
                    RecordID
GO
