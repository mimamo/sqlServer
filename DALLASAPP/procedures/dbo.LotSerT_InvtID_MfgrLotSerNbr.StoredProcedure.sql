USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_InvtID_MfgrLotSerNbr]    Script Date: 12/21/2015 13:44:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerT_InvtID_MfgrLotSerNbr    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.LotSerT_InvtID_MfgrLotSerNbr    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[LotSerT_InvtID_MfgrLotSerNbr] @parm1 varchar (30), @parm2 varchar (25)  as
    Select * from LotSerT where InvtID = @parm1
	        and MfgrLotSerNbr = @parm2
                order by LotSerNbr
GO
