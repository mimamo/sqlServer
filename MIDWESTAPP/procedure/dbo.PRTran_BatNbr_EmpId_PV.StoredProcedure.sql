USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_BatNbr_EmpId_PV]    Script Date: 12/21/2015 15:55:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRTran_BatNbr_EmpId_PV] @parm1 varchar (10), @parm2 varchar (10), @parm3 varchar (10)
as
    Select * From vs_PRTran
     Where ((BatNbr <> '' and BatNbr = @parm1)
        or (BatNbr = '' and EmpId NOT IN(select EmpId from vs_PRTran where BatNbr <> '' and BatNbr = @parm2)))
       and EmpId Like @parm3
  Order By CurrBatNbr DESC,
           EmpId
GO
