USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_Prog_RefNbr_InvtId]    Script Date: 12/21/2015 15:42:59 ******/
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
