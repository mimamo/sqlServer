USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_Prog_RefNbr_InvtId]    Script Date: 12/21/2015 16:01:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LotSerT_Prog_RefNbr_InvtId] @parm1 varchar (8), @parm2 varchar (15), @parm3 varchar (30) as
    	Select * from LotSerT where
		Crtd_Prog = @parm1 and
		RefNbr = @parm2 and
		InvtId = @parm3
      order by LotSerNbr
GO
