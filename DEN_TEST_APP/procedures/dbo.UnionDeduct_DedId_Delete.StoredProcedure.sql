USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[UnionDeduct_DedId_Delete]    Script Date: 12/21/2015 15:37:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[UnionDeduct_DedId_Delete] @parm1 varchar (10) as
           Delete UnionDeduct from UnionDeduct Where DedId = @parm1
GO
