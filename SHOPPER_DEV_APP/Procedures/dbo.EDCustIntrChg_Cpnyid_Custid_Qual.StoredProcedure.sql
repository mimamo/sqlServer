USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCustIntrChg_Cpnyid_Custid_Qual]    Script Date: 12/21/2015 14:34:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCustIntrChg_Cpnyid_Custid_Qual] @Parm1 varchar(10), @Parm2 varchar(15), @Parm3 varchar(2) As
Select * From EDCustIntrChg Where Cpnyid = @Parm1 And Custid = @Parm2
And Qualifier = @Parm3
GO
