USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_BatNbr_Project_PV]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRTran_BatNbr_Project_PV] @parm1 varchar (10), @parm2 varchar (10), @parm3 varchar (16)
as
    Select * From vs_PRTran2
     Where ((BatNbr <> '' and BatNbr = @parm1)
        or (BatNbr = '' and Project NOT IN(select Project from vs_PRTran2 where BatNbr <> '' and BatNbr = @parm2)))
       and Project Like @parm3
  Order By CurrBatNbr DESC,
           Project
GO
