USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDCustIntrChg_LookUp]    Script Date: 12/21/2015 16:13:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCustIntrChg_LookUp] @SenderId varchar(15) As
Select Count(*), Max(CustId) From EDCustIntrChg Where Qualifier = 'ZZ' And Id = @SenderId
GO
