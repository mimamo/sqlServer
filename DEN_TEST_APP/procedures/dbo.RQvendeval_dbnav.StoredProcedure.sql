USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQvendeval_dbnav]    Script Date: 12/21/2015 15:37:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[RQvendeval_dbnav] @parm1 Varchar(10), @Parm2 Varchar(60), @parm3 varchar(15) as
Select * from RQvendeval where reqnbr = @parm1
and Name Like @parm2
and VendID like @parm3
Order by reqnbr, Name, Vendid
GO
