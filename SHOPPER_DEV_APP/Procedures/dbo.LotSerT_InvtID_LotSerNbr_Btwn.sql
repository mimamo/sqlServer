USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_InvtID_LotSerNbr_Btwn]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LotSerT_InvtID_LotSerNbr_Btwn] @parm1 varchar (30), @parm2 varchar (25), @Parm3 varchar (25) as
    	Select * from LotSerT where
		InvtID = @parm1 and
		LotSerNbr >= @parm2 and
		LotSerNbr <= @Parm3
                order by LotSerNbr
GO
