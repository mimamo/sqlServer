USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCustIntrChg_CpnyId_Custid]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDCustIntrChg_CpnyId_Custid] @Parm1 varchar(10), @Parm2 varchar(15) As
Select * From EDCustIntrChg Where Cpnyid like @Parm1 And Custid like @Parm2
Order By Id Desc
GO
