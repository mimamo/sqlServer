USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDTerms_GlobalCodes]    Script Date: 12/21/2015 16:07:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDTerms_GlobalCodes] @TermsId varchar(2) As
Select TermsBasisCode, TermsTypeCode From EDTerms Where TermsId = @TermsId And TermsType = 'G'
GO
