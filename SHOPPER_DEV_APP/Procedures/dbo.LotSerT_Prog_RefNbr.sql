USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_Prog_RefNbr]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LotSerT_Prog_RefNbr] @parm1 varchar (8), @parm2 varchar (15) as
    	Select * from LotSerT where
		Crtd_Prog = @parm1 and
		RefNbr = @parm2
                order by LotSerNbr
GO
