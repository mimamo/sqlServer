USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRServCall_InvtId]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRServCall_InvtId] @parm1 varchar (30) as
        Select * from Inventory
                where InvtId like @parm1
                  and StkItem = 0
                  and InvtType = 'L'
        Order by InvtId
GO
