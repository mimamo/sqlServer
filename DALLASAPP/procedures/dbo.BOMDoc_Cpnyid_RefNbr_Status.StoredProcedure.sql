USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[BOMDoc_Cpnyid_RefNbr_Status]    Script Date: 12/21/2015 13:44:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BOMDoc_Cpnyid_RefNbr_Status] @parm1 varchar ( 10), @parm2 varchar (15) as
    Select * from BOMDoc where Status <> 'V' and
	Cpnyid = @parm1 and
	RefNbr like @parm2
	order by Cpnyid, RefNbr
GO
