USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreditInfo_TermsCOD]    Script Date: 12/21/2015 14:17:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreditInfo_TermsCOD]
	@TermsID	varchar(15)
as
	select	COD
	from	Terms (nolock)
	where	TermsID = @TermsID
GO
