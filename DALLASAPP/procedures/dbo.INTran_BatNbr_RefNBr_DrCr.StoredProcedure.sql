USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_BatNbr_RefNBr_DrCr]    Script Date: 12/21/2015 13:44:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[INTran_BatNbr_RefNBr_DrCr] @BatNbr varchar ( 10),
	@RefNbr varchar (15), @DrCr varchar (10) as
	Select * from INTran
		Where BatNbr = @BatNbr
		and RefNbr = @RefNbr
		and DrCr = @DrCr
           	order by BatNbr, RefNbr
GO
