USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_Acct_Sub_Class_RefNbr]    Script Date: 12/21/2015 16:13:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_Acct_Sub_Class_RefNbr    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APDoc_Acct_Sub_Class_RefNbr]
@parm1 varchar ( 10), @parm2 varchar ( 24), @parm3 varchar ( 1), @parm4 varchar ( 10) as
Select * from APDoc where Acct = @parm1
and Sub = @parm2
and DocClass = @parm3
and RefNbr like @parm4
and Status <> 'V'
and DocType IN ('CK', 'HC')
Order by Acct, Sub, DocType, RefNbr
GO
