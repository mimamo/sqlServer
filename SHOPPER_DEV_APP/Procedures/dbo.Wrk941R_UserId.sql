USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Wrk941R_UserId]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Wrk941R_UserId] @parm1 varchar ( 47) as
       Select * From Wrk941R
           where UserId  =  @parm1
           order by UserId
GO
