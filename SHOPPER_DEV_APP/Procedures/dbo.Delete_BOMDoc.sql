USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_BOMDoc]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Delete_BOMDoc] @parm1 varchar (10) as
    Delete bomdoc
			from BOMDoc
				left outer join BOMTran
					on BOMDoc.RefNbr = BOMTran.RefNbr
            where (BOMDoc.PerPost <= @parm1 and BOMDoc.PerPost IS NOT NULL)
GO
