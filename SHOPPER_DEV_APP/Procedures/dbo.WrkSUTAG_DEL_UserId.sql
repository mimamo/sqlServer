USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkSUTAG_DEL_UserId]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[WrkSUTAG_DEL_UserId] @parm1 varchar ( 47) as
       Delete wrksutag from WrkSUTAG
           where UserId   =  @parm1
GO
