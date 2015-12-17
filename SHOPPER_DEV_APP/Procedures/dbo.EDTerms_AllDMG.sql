USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDTerms_AllDMG]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDTerms_All    Script Date: 5/28/99 1:17:46 PM ******/
CREATE Proc [dbo].[EDTerms_AllDMG] @Parm1 varchar(2), @parm2  varchar(15) As
select * from EDTerms where TermsId like @parm1 and CustId like @parm2 order by TermsId, CustId
GO
