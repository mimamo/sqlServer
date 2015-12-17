USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BM_BOMDoc_Cpnyid_RefNbr]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BM_BOMDoc_Cpnyid_RefNbr] @parm1 varchar ( 10), @parm2 varchar (15) as
    Select * from BOMDoc where
	Cpnyid = @parm1 and
	RefNbr = @parm2
	order by Cpnyid, RefNbr
GO
