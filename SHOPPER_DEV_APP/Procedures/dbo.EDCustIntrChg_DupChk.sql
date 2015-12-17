USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCustIntrChg_DupChk]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCustIntrChg_DupChk] @Parm1 varchar(2), @Parm2 varchar(15), @Parm3 varchar(20) As
Select CustId From EDCustIntrChg Where Qualifier = @Parm1 And Id = @Parm2
And EDIBillToRef = @Parm3
GO
