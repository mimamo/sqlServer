USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCustIntrChg_LookUp]    Script Date: 12/21/2015 16:07:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCustIntrChg_LookUp] @SenderId varchar(15) As
Select Count(*), Max(CustId) From EDCustIntrChg Where Qualifier = 'ZZ' And Id = @SenderId
GO
