USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOReasonCode_Acct_Sub]    Script Date: 12/21/2015 15:55:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[WOReasonCode_Acct_Sub]
	@ReasonCd	varchar(6)
as
	select		DfltAcct, DfltSub
	from		ReasonCode
	where		ReasonCd = @ReasonCd
GO
