USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_QCPP_RefNbr]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_QCPP_RefNbr    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APDoc_QCPP_RefNbr] @parm1 varchar(1), @parm2 varchar ( 10) as
Select * From APDoc
Where DocClass = @parm1 and (APDoc.DocType = 'VO' OR APDoc.DocType = 'PP')
and APDoc.RefNbr LIKE @parm2 and Status <> 'V'
Order by RefNbr
GO
