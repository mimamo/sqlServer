USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Component_CmpnentId]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Component_CmpnentId    Script Date: 4/17/98 10:58:16 AM ******/
/****** Object:  Stored Procedure dbo.Component_CmpnentId    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[Component_CmpnentId] @parm1 varchar ( 30) as
            Select * from Component where CmpnentId = @parm1
                order by CmpnentId
GO
