USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDTerms_ApplyTo]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDTerms_ApplyTo]
	@TermsID	varchar(2)
AS
-- Select termsid, descr From Terms, XDDSetup Where ApplyTo IN ('C','B') and TermsID LIKE rtrim(XDDSetup.ARTermsID) and TermsID LIKE @TermsID order by TermsID
Select Terms.* From Terms, XDDSetup Where ApplyTo IN ('C','B') and TermsID LIKE rtrim(XDDSetup.ARTermsID) and TermsID LIKE @TermsID order by TermsID
GO
