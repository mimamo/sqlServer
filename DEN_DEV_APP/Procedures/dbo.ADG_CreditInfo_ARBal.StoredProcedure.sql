USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreditInfo_ARBal]    Script Date: 12/21/2015 14:05:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreditInfo_ARBal]
	@CpnyID		varchar(10),
	@CustID		varchar(15),
	@RlsedExcl	smallint
as
	select	isnull(sum(	case when ar.DocType in ('CM', 'DA', 'PA', 'PP') then -ar.DocBal
				else ar.DocBal
				end), 0)

	from	ARDoc ar (nolock)
	left 	join Terms t (nolock)
	on	t.TermsID = ar.Terms

	where	ar.CustID = @CustID
	and	ar.Rlsed <> @RlsedExcl
--	and	ar.CpnyID = @CpnyID
	and	ar.DocBal <> 0
	and	isnull(t.CreditChk, 1) = 1
GO
