USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRCheckTrans_BatNbr_ChkSeq]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRCheckTrans_BatNbr_ChkSeq] @BatNbr varchar (10),
                                       @ChkSeq varchar (2),
                                       @EmpId  varchar (10) as
    select p.* from PRCheckTran p, Employee e
              where p.EmpId      = e.EmpId
                and p.EmpId      = @EmpId
                and p.ChkSeq     = @ChkSeq
		and p.ASID	 = 0
                and e.CurrBatNbr = @BatNbr
GO
