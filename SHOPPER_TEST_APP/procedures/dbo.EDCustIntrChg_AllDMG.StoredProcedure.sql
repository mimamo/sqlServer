USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCustIntrChg_AllDMG]    Script Date: 12/21/2015 16:07:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDCustIntrChg_All    Script Date: 5/28/99 1:17:40 PM ******/
CREATE Proc [dbo].[EDCustIntrChg_AllDMG] @Parm1 varchar(15), @Parm2 varchar(2), @Parm3 varchar(15), @Parm4 varchar(20) As
Select * From EDCustIntrChg Where CustId = @Parm1 And Qualifier Like @Parm2
And Id Like @Parm3 And CpnyId Like @Parm4
Order By CustId, Qualifier, Id, CpnyId
GO
