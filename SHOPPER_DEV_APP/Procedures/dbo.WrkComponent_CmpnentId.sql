USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkComponent_CmpnentId]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.WrkComponent_CmpnentId    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.WrkComponent_CmpnentId    Script Date: 4/16/98 7:41:53 PM ******/
Create Proc  [dbo].[WrkComponent_CmpnentId] @parm1 varchar ( 30) as
       Select * from WrkComponent
           where CmpnentId  =  @parm1
           order by CmpnentId
GO
