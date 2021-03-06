USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10223_Fetch_PODate]    Script Date: 12/21/2015 15:55:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10223_Fetch_PODate]
	@RcptNbr	VarChar(15)
As
	select PODate from PurchOrd
	join (select distinct t.ponbr from poreceipt r
	inner join potran t on t.rcptnbr = r.rcptnbr where r.RcptNbr = @RcptNbr) v on v.ponbr = PurchOrd.ponbr
GO
