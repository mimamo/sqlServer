USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDTerms_CustOrGlobal]    Script Date: 12/21/2015 14:06:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDTerms_CustOrGlobal] @TermsId varchar(2), @CustId varchar(15) As
Select * From EDTerms Where TermsId = @TermsId And CustId In (@CustId, '*') Order By TermsType
GO
