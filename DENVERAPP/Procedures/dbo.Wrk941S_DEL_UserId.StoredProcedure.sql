USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Wrk941S_DEL_UserId]    Script Date: 12/21/2015 15:43:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Wrk941S_DEL_UserId] @parm1 varchar ( 47) as
       Delete wrk941s from Wrk941S
           where UserId   =  @parm1
GO
