USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRServCall_InvtId]    Script Date: 12/21/2015 13:45:03 ******/
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
