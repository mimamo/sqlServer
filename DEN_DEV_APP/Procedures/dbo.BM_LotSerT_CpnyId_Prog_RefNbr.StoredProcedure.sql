USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BM_LotSerT_CpnyId_Prog_RefNbr]    Script Date: 12/21/2015 14:05:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BM_LotSerT_CpnyId_Prog_RefNbr] @CpnyId varchar (10), @Prog varchar (8), @RefNbr varchar (15) as
    	Select * from LotSerT where
		CpnyId = @CpnyId and
		Crtd_Prog = @Prog and
		RefNbr = @RefNbr
        Order By LotSerNbr
GO
