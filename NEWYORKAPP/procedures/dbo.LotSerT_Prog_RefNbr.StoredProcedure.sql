USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_Prog_RefNbr]    Script Date: 12/21/2015 16:01:06 ******/
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
