USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_InvtID_TranType]    Script Date: 12/21/2015 14:06:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerT_InvtID_TranType    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.LotSerT_InvtID_TranType    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[LotSerT_InvtID_TranType] @parm1 varchar (30), @parm2 varchar (2) as
    Select * from LotSerT where InvtID = @parm1
	        and TranType = @parm2
                order by LotSerNbr
GO
