USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Wrk941R_DEL_UserId]    Script Date: 12/21/2015 14:34:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Wrk941R_DEL_UserId] @parm1 varchar ( 47) as
       Delete wrk941r from Wrk941R
           where UserId   =  @parm1
GO
