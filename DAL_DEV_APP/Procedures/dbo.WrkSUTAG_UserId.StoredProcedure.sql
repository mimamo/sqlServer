USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkSUTAG_UserId]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[WrkSUTAG_UserId] @parm1 varchar ( 47) as
       Select * From WrkSUTAG
           where UserId  =  @parm1
           order by UserId
GO
