USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDFrtTerms_Collect]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDFrtTerms_Collect] @FrtTermsId varchar(10) As
Select Collect From FrtTerms Where FrtTermsId = @FrtTermsId
GO
