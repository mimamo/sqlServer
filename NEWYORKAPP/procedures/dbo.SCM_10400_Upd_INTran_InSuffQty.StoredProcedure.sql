USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_Upd_INTran_InSuffQty]    Script Date: 12/21/2015 16:01:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_Upd_INTran_InSuffQty]
	@RecordID	Integer,
	@QtyUnCosted	Float,
	@InSuffQty	SmallInt,
	@LUpd_Prog	Varchar(8),
	@LUpd_User	Varchar(10)
As
	Update	INTran
		Set	QtyUnCosted = @QtyUnCosted,
			InSuffQty = @InSuffQty,
			LUpd_Prog = @LUpd_Prog,
			LUpd_User = @LUpd_User
		Where	RecordID = @RecordID
GO
