USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCustIntrChg_LookUp]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCustIntrChg_LookUp] @SenderId varchar(15) As
Select Count(*), Max(CustId) From EDCustIntrChg Where Qualifier = 'ZZ' And Id = @SenderId
GO
